# rubocop:disable Metrics/ClassLength
class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]

  # GET /items or /items.json
  def index
    @items = Item.all
  end

  # GET /items/1 or /items/1.json
  def show
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
    @item = Item.find(params[:id])
    @user = current_user
    @item.holder = @user.id
    @item.set_status_lent
    @item.save

    redirect_to item_url(@item)
  end

  def request_return
    @item = Item.find(params[:id])
    @item.request_return
    @item.save
    @user = current_user
    unless ReturnRequestNotification.find_by(item: @item)
      @notification = ReturnRequestNotification.new(user: User.find(@item.owner), date: Time.zone.now, item: @item,
                                                    borrower: @user)
      @notification.save
    end
    redirect_to item_url(@item)
  end

  def accept_lend
    @item = Item.find(params[:id])
    @notification = LendRequestNotification.find_by(item: @item)
    @item.set_status_lent
    @item.holder = @notification.borrower.id
    @item.save
  end

  def accept_return
    @item = Item.find(params[:id])
    @notification = ReturnRequestNotification.find_by(item: @item)
    @notification.destroy
    # TODO: Send return accepted notification to borrower
    @item.accept_return
    @item.save
    redirect_to item_url(@item)
  end

  def deny_return
    @item = Item.find(params[:id])
    @notification = ReturnRequestNotification.find_by(item: @item)
    @notification.destroy
    # TODO: Send return declined notification to borrower and handle decline return
    @item.deny_return
    @item.save
    redirect_to item_url(@item)
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

  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:name, :category, :location, :description, :image, :price_ct, :rental_duration_sec,
                                 :rental_start, :return_checklist, :owner, :holder, :waitlist_id, :lend_status)
  end
end

# rubocop:enable Metrics/ClassLength
