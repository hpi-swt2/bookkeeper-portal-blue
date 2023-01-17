class GroupsController < ApplicationController
  before_action :check_owner, only: %i[ remove ]

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owners.append(current_user)
    if @group.save
      redirect_to @group
    else
      render :new
    end
  end

  def promote
    @group = Group.find(params[:id])

    if @group.owners.include?(current_user)
      @user = User.find(params[:user_id])
      @user.to_owner_of! @group
    end

    redirect_to @group
  end

  def demote
    @group = Group.find(params[:id])

    if @group.owners.include?(current_user)
      @user = User.find(params[:user_id])
      @user.to_member_of! @group
    end

    redirect_to @group
  end

  def remove
    @group = Group.find(params[:id])
    @user = User.find(params[:user_id])
    if @group.members_without_ownership.include?(@user)
      @user.groups.delete(@group)
      @notification = RemovedFromGroupNotification.new(receiver: @user, date: Time.zone.now, group_name: @group.name,
                                                       active: false, unread: true).save
    end
    redirect_to @group
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
