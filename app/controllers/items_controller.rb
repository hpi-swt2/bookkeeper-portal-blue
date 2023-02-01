require "rqrcode"
require "prawn"
require "stringio"

# rubocop:disable Metrics/ClassLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity

class ItemsController < ApplicationController
  before_action :set_item, except: %i[ index new create ]

  before_action :set_lendable, only: %i[ show ]
  before_action :check_lendable, only: %i[ request_lend add_to_waitlist ]

  before_action :check_seeable, except: %i[ index new create ]
  before_action :set_groups_with_current_user, only: %i[ new edit create update ]

  # GET /items or /items.json
  def index
    return redirect_to root_url if current_user.nil?

    @items = current_user.visible_items
  end

  # GET /items/1 or /items/1.json
  def show
    @item = Item.find(params[:id])

    @avg_lend_time = helpers.statistics_item_lend_time(@item)
    @avg_lend_time_min, @avg_lend_time_sec = @avg_lend_time.divmod(60)
    @avg_lend_time_hour, @avg_lend_time_min = @avg_lend_time_min.divmod(60)
    @avg_lend_time_day, @avg_lend_time_hour = @avg_lend_time_hour.divmod(24)

    return unless @item.waitlist.nil?

    @item.waitlist = Waitlist.new
    @item.save
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
    @owner_id = @item.owning_user.nil? ? "group:#{@item.owning_group.id}" : "user:#{@item.owning_user.id}"
    @lend_group_ids = @item.groups_with_lend_permission.map(&:id)
    @see_group_ids = (@item.groups_with_see_permission - @item.groups_with_lend_permission).map(&:id)
  end

  # POST /items or /items.json
  def create
    params = item_params.merge!(permission_hash)
    params[:image] = params[:image].read unless params[:image].nil?
    @item = Item.new(params)
    @item.clear_subclass_fields
    return render file: "public/422.html", status: :unprocessable_entity unless @item.valid?

    @item.waitlist = Waitlist.new
    @item.set_status_lent unless @item.holder.nil?

    create_create_response
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    @item = @item.becomes!(Item.valid_types[params[:item][:type]])
    @item.assign_attributes(item_params)
    @item.clear_subclass_fields
    respond_to do |format|
      if update_with_permissions
        format.html { redirect_to item_url(@item), notice: t("models.item.updated") }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # Due to the way we handle permissions, `@item.update` can't be used to update them
  # This method applies all "simple" updates with the usual `@item.update` and then handles the permissions separately
  def update_with_permissions
    false if @item.save

    lend_group_ids =
      if params.require(:item)[:lend_group_ids].nil?
        @item.groups_with_lend_permission.map(&:id)
      else
        params.require(:item)[:lend_group_ids].compact_blank!
      end

    see_group_ids =
      if params.require(:item)[:see_group_ids].nil?
        @item.groups_with_see_permission.map(&:id)
      else
        params.require(:item)[:see_group_ids].compact_blank!
      end

    see_group_ids -= lend_group_ids

    if @item.owning_group.nil?
      @item.groups_with_lend_permission.delete_all
      @item.groups_with_see_permission.delete_all
    else
      @item.groups_with_lend_permission.delete_if { |group| group != @item.owning_group }
      @item.groups_with_see_permission.delete_if { |group| group != @item.owning_group }
    end

    lend_group_ids.each do |group_id|
      @item.groups_with_lend_permission << Group.find(group_id)
    end

    see_group_ids.each do |group_id|
      @item.groups_with_see_permission << Group.find(group_id)
    end

    @item.save
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy

    respond_to do |format|
      format.html { redirect_to dashboard_url, notice: t("models.item.destroyed") }
      format.json { head :no_content }
    end
  end

  def add_to_waitlist
    @user = current_user

    helpers.audit_add_to_waitlist(@item)

    create_add_to_waitlist_response
  end

  def leave_waitlist
    @user = current_user
    @item.remove_from_waitlist(@user)
    @item.save

    helpers.audit_leave_waitlist(@item)

    redirect_to item_url(@item)
  end

  def add_to_favorites
    @user = current_user
    @user.favorites << (@item)
    redirect_to item_url(@item), notice: t("views.show_item.enter_favorites")
  end

  def leave_favorites
    @user = current_user
    @user.favorites.delete(@item)
    redirect_to item_url(@item), notice: t("views.show_item.leave_favorites")
  end

  def request_lend
    @user = current_user
    @owner = @item.owning_user.nil? ? @item.owning_group.members[0] : @item.owning_user
    @notification = LendRequestNotification.new(item: @item, borrower: @user, receiver: @owner, date: Time.zone.now,
                                                unread: true, active: true)
    @notification.save
    @item.set_status_pending_lend_request
    @item.save

    helpers.audit_request_lend(@item)

    redirect_to item_url(@item)
  end

  def start_lend
    @job = Job.find_by(item: @item)
    @job.destroy
    @holder = current_user.id
    @item.set_status_lent
    @item.set_rental_start_time
    @item.holder = @holder
    @item.save
    redirect_to item_url(@item)
  end

  def abort_lend
    @job = Job.find_by(item: @item)
    @job.destroy
    @item.set_status_available
    @item.holder = nil
    @item.save
    redirect_to item_url(@item)
  end

  def request_return
    @item.set_status_pending_return
    @item.save
    helpers.audit_request_return(@item)
    notified_user = @item.owning_user.nil? ? @item.owning_group.members[0] : @item.owning_user
    @notification = ReturnRequestNotification.new(receiver: notified_user, date: Time.zone.now,
                                                    item: @item, borrower: current_user, active: true, unread: true)
    @notification.save
    redirect_to item_url(@item)
  end

  def generate_qrcode
    qr = RQRCode::QRCode.new("item:#{params[:id]}")
    png = qr.as_png(size: 500)
    dummy_png_file = StringIO.new png.to_blob
    pdf = Prawn::Document.new(page_size: "A4")
    pdf.image dummy_png_file, position: :center
    send_data pdf.render, disposition: "attachment", type: "application/pdf"
  end

  def image
    send_data @item.image
  end

  private

  def create_create_response
    respond_to do |format|
      if @item.save
        helpers.audit_create_item(@item)
        format.html { redirect_to item_url(@item), notice: t("models.item.created") }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_add_to_waitlist_response
    respond_to do |format|
      if @item.add_to_waitlist(@user) && @item.save
        format.html do
          redirect_to item_url(@item),
                      notice: t("models.waitlist.added_to_waitlist", position: @item.waitlist.position(@user) + 1)
        end
      else
        format.html { redirect_to item_url(@item), alert: t("models.waitlist.failed_adding_to_waitlist") }
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_url, alert: t("models.item.not_found")
  end

  def check_seeable
    seeable = @item.users_with_see_permission.include?(current_user) || @item.holder == current_user.id
    render file: 'public/403.html', status: :forbidden unless seeable
  end

  def set_groups_with_current_user
    @groups_with_current_user = Group.all.filter { |group| group.members.include? current_user }
  end

  def set_lendable
    @lendable = @item.users_with_lend_permission.include?(current_user)
  end

  def check_lendable
    set_lendable
    render file: 'public/403.html', status: :forbidden unless @lendable
  end

  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:name, :category, :location, :description, :image, :price_ct, :rental_duration_sec,
                                 :rental_start, :return_checklist, :holder, :waitlist_id, :lend_status, :type, :title,
                                 :genre, :movie_duration, :author, :page_count, :player_count)
          .merge!(owner_hash)
  end

  def owner_hash
    owner_id = params.require(:item)[:owner_id]
    if owner_id.nil?
      {}
    else
      user_or_group, id = owner_id.split(":")
      case user_or_group
      when "group"
        { owning_group: Group.find(id.to_i) }
      else # "user" as default
        { owning_user: User.find(id.to_i) }
      end
    end
  end

  def permission_hash
    lend_group_ids = params.require(:item)[:lend_group_ids].compact_blank!
    see_group_ids = params.require(:item)[:see_group_ids].compact_blank!

    see_group_ids -= lend_group_ids

    {
      groups_with_see_permission: Group.find(see_group_ids),
      groups_with_lend_permission: Group.find(lend_group_ids)
    }
  end
end

# rubocop:enable Metrics/ClassLength
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
