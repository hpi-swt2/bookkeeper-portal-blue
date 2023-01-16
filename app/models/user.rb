# User model which has a first name, last name and full name
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:openid_connect]
  has_many :notifications, dependent: :destroy
  has_and_belongs_to_many :items, join_table: "wishlist"

  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships

  has_many :ownerships, class_name: 'Ownership', dependent: :destroy
  has_many :owned_groups, through: :ownerships, source: :group

  has_many :permissions, as: :user_or_group, dependent: :destroy
  has_many :see_permissions, class_name: 'SeePermission', as: :user_or_group, dependent: :destroy
  has_many :lend_permissions, class_name: 'LendPermission', as: :user_or_group, dependent: :destroy
  has_many :ownership_permissions, class_name: 'OwnershipPermission', as: :user_or_group, dependent: :destroy

  has_many :directly_visible_items, through: :see_permissions, source: :item
  has_many :directly_lendable_items, through: :lend_permissions, source: :item
  has_many :directly_owned_items, through: :ownership_permissions, source: :item

  has_many :indirectly_visible_items, through: :groups, source: :visible_items
  has_many :indirectly_lendable_items, through: :groups, source: :lendable_items
  has_many :indirectly_owned_items, through: :groups, source: :owned_items

  has_and_belongs_to_many :waitlists

  def email_parts
    email.split("@")[0].split(".")
  end

  # Method expects all emails to follow format "firstname.lastname@anything" in order to extract first name out of email
  def first_name
    email_parts[0].capitalize
  end

  def wishlist
    items
  end

  # Method expects all emails to follow format "firstname.lastname@anything" in order to extract last name out of email
  # If no last name is found, an empty string is returned
  def last_name
    if email_parts.length <= 1
      ""
    else
      email_parts[1].capitalize
    end
  end

  def name
    "#{first_name} #{last_name}".strip
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

  def visible_items
    directly_visible_items + indirectly_visible_items
  end

  def lendable_items
    directly_lendable_items + indirectly_lendable_items
  end

  def owned_items
    directly_owned_items + indirectly_owned_items
  end

  def self.from_omniauth(auth)
    # Create user in database if it does not exist yet when logging in via OIDC
    where(email: auth.info.email).first_or_create! do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def owns_group?(group)
    owned_groups.include?(group)
  end
end
