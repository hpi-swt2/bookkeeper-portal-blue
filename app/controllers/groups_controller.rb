class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show promote demote add_user ]
  before_action :check_owner, only: %i[ promote demote add_user ]

  def show
    @addable_users = User.all - @group.members
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
    @user = User.find(params[:user_id])
    @user.to_owner_of! @group

    redirect_to @group
  end

  def demote
    @user = User.find(params[:user_id])
    @user.to_member_of! @group

    redirect_to @group
  end

  def add_user
    respond_to do |format|
      user = User.find(params[:user_id])
      if user.nil?
        format.html { render :show, status: :unprocessable_entity }
      else
        user.to_member_of!(@group)
        format.html { redirect_to @group, notice: t("views.groups.user_added", user: user.name) }
      end
    end
  end

  def group_params
    params.require(:group).permit(:name)
  end

  def set_group
    @group = Group.find(params[:id])
  end

  def check_owner
    redirect_to @group unless @group.owners.include?(current_user)
  end
end
