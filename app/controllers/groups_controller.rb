class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show create promote demote add_user ]

  def show
  end

  def new
    @group = Group.new
  end

  def create
    @group.owners.append(current_user)
    if @group.save
      redirect_to @group
    else
      render :new
    end
  end

  def promote
    if @group.owners.include?(current_user)
      @user = User.find(params[:user_id])
      @user.to_owner_of! @group
    end

    redirect_to @group
  end

  def demote
    if @group.owners.include?(current_user)
      @user = User.find(params[:user_id])
      @user.to_member_of! @group
    end

    redirect_to @group
  end

  def add_user
    user = User.find(params[:user_id])
    if user.nil?
      format.html { render :show, status: :unprocessable_entity }
    else
      user.to_member_of!(@group)
      format.html { redirect_to @group, notice: t("views.groups.user_addded", user: user.name) }
    end
  end

  def group_params
    params.require(:group).permit(:name)
  end

  def set_group
    @group = Group.find(params[:id])
  end
end
