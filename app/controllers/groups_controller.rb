class GroupsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_group, only: %i[ remove add_member promote demote leave]
  before_action :check_owner, only: %i[ remove ]

  before_action :set_user, only: %i[ add_member promote demote remove]

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
    @user.to_owner_of! @group if @group.owners.include?(current_user)

    redirect_to @group
  end

  def demote
    @user.to_member_of! @group if @group.owners.include?(current_user)

    redirect_to @group
  end

  def remove
    if @group.members_without_ownership.include?(@user)
      @user.groups.delete(@group)
      @notification = RemovedFromGroupNotification.new(receiver: @user, date: Time.zone.now, group_name: @group.name,
                                                       active: false, unread: true).save
    end
    redirect_to @group
  end

  def leave
    @group.members.delete(current_user)
    redirect_to @group
  end

  def group_params
    params.require(:group).permit(:name)
  end

  def add_member
    unless current_user.owns_group?(@group)
      return render file: 'public/403.html',
                    status: :unauthorized
    end
    unless @group.members.include?(@user)
      @group.members.append(@user)
      @notification = AddedToGroupNotification.new(receiver: @user, date: Time.zone.now, group_name: @group.name,
                                                   active: false, unread: true).save
    end
    redirect_to @group
  end

  def set_group
    @group = Group.find(params[:id])
  end

  def check_owner
    redirect_to @group unless @group.owners.include?(current_user)
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
