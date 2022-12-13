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

  def leave_waitlist
    @item = Item.find(params[:id])
    @user = current_user
    @item.remove_from_waitlist(@user)
    @item.save
    redirect_to item_url(@item)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:name, :category, :location, :description, :image, :price_ct, :rental_duration_sec,
                                 :rental_start, :return_checklist, :owner, :holder, :waitlist_id)
  end
end
