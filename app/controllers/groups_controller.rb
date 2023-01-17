class GroupsController < ApplicationController
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

    if @group.owners.include?(current_user)
      @user = User.find(params[:user_id])
      @user.groups.delete(@group) if @group.owners.exclude?(@user) && @group.members.include?(@user)
    end

    redirect_to @group
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
