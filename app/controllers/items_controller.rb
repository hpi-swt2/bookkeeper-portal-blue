require "rqrcode"
require "prawn"
require "stringio"

# rubocop:disable Metrics/ClassLength
class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy request_return accept_return request_lend accept_lend]
  before_action :set_owner, only: %i[ accept_lend]

  # GET /items or /items.json
  def index
    @items = Item.all
  end

  # GET /items/1 or /items/1.json
  def show
    @item = Item.find(params[:id])
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
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)
    @item.waitlist = Waitlist.new
    @item.set_status_lent unless @item.holder.nil?

    create_create_response
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to item_url(@item), notice: t("models.item.updated") }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url, notice: t("models.item.destroyed") }
      format.json { head :no_content }
    end
  end

  def add_to_waitlist
    @item = Item.find(params[:id])
    @user = current_user

    create_add_to_waitlist_response
  end

  def leave_waitlist
    @item = Item.find(params[:id])
    @user = current_user
    @item.remove_from_waitlist(@user)
    @item.save
    redirect_to item_url(@item)
  end

  def request_lend
    @user = current_user
    @owner = User.find(@item.owner)
    @notification = LendRequestNotification.new(item: @item, borrower: @user, receiver: @owner, date: Time.zone.now,
                                                unread: true, active: true)
    @notification.save
    @item.set_status_pending_lend_request
    @item.save
    redirect_to item_url(@item)
  end

  def accept_lend
    @notification = LendRequestNotification.find_by(item: @item)
    @item.set_status_lent
    @item.holder = @notification.borrower.id
    @notification.update(active: false)
    @lendrequest = LendRequestNotification.find(@notification.actable_id)
    @lendrequest.update(accepted: true)
    @item.save
    LendingAcceptedNotification.create(item: @item, user: @owner, date: Time.zone.now)
    redirect_to item_url(@item)
  end

  def request_return
    @item.set_status_pending_return
    @item.save
    @user = current_user
    unless ReturnRequestNotification.find_by(item: @item)
      @notification = ReturnRequestNotification.new(receiver: User.find(@item.owner), date: Time.zone.now,
                                                    item: @item, borrower: @user, active: true, unread: true)
      @notification.save
    end
    redirect_to item_url(@item)
  end

  def accept_return
    @user = current_user
    @request_notification = ReturnRequestNotification.find_by(item: @item)
    @request_notification.destroy
    @accepted_notif = ReturnAcceptedNotification.new(active: true, unread: true, date: Time.zone.now,
                                                     item: @item, receiver: User.find(@item.holder), owner: @user)
    @accepted_notif.save
    @item.reset_status
    @item.save
    redirect_to item_url(@item)
  end

  def deny_return
    @item = Item.find(params[:id])
    @user = current_user
    @request_notification = ReturnRequestNotification.find_by(item: @item)
    @request_notification.destroy
    @declined_notification = ReturnDeclinedNotification.new(item_name: @item.name, owner: @user,
                                                            receiver: User.find(@item.holder),
                                                            date: Time.zone.now, active: true, unread: true)
    @declined_notification.save
    @item.destroy
    redirect_to notifications_path
  end

  def generate_qrcode
    qr = RQRCode::QRCode.new("item:#{params[:id]}")
    png = qr.as_png(size: 500)
    dummy_png_file = StringIO.new png.to_blob
    pdf = Prawn::Document.new(page_size: "A4")
    pdf.image dummy_png_file, position: :center
    send_data pdf.render, disposition: "attachment", type: "application/pdf"
  end

  private

  def create_create_response
    respond_to do |format|
      if @item.save
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
  end

  def set_owner
    @owner = User.find(@item.owner)
  end

  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:name, :category, :location, :description, :image, :price_ct, :rental_duration_sec,
                                 :rental_start, :return_checklist, :owner, :holder, :waitlist_id, :lend_status)
  end
end

# rubocop:enable Metrics/ClassLength
