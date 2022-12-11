# User model which has a first name, last name and full name
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :notifications, dependent: :destroy

  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships

  has_many :ownerships, class_name: 'Ownership', dependent: :destroy
  has_many :owned_groups, through: :ownerships, source: :group

  has_and_belongs_to_many :waitlists

  # Method expects all emails to follow format "firstname.lastname@anything" in order to extract first name out of email
  def first_name
    email.split("@")[0].split(".")[0].capitalize
  end

  # Method expects all emails to follow format "firstname.lastname@anything" in order to extract last name out of email
  def last_name
    email.split("@")[0].split(".")[1].capitalize
  end

  def name
    "#{first_name} #{last_name}"
  end

  # Promote this user to an owner of group. Add the user if they are not a member already.
  # Use `group.owners.append(user)` or `user.owned_groups.append(user)` if you just want to add a new owner.
  def to_owner_of!(group)
    memberships.where(group: group).first_or_create!.becomes!(Ownership).save
    group.reload
    reload
  end

  # Demote this user to a non-owner member of group. Add the user if they are not a owner already.
  # Use `group.members.append(user)` or `user.groups.append(user)` if you just want to add a member.
  def to_member_of!(group)
    memberships.where(group: group).first_or_create!.becomes!(Membership).save
    group.reload
    reload
  end
end
