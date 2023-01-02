# class of a basic item.
class Item < ApplicationRecord
  has_one_attached :image
  has_one :waitlist, dependent: :destroy
  has_many :lend_request_notifications, dependent: :destroy
  has_and_belongs_to_many :users, join_table: "wishlist"

  has_many :permissions, dependent: :destroy
  has_many :see_permissions, class_name: 'SeePermission', dependent: :destroy
  has_many :lend_permissions, class_name: 'LendPermission', dependent: :destroy
  has_one :ownership_permission, class_name: 'OwnershipPermission', dependent: :destroy

  has_many :groups_with_see_permission, through: :see_permissions, source: :user_or_group, source_type: 'Group'
  has_many :users_with_direct_see_permission, through: :see_permissions, source: :user_or_group, source_type: 'User'
  has_many :users_with_indirect_see_permission, through: :groups_with_see_permission, source: :members

  has_many :groups_with_lend_permission, through: :lend_permissions, source: :user_or_group, source_type: 'Group'
  has_many :users_with_direct_lend_permission, through: :lend_permissions, source: :user_or_group, source_type: 'User'
  has_many :users_with_indirect_lend_permission, through: :groups_with_lend_permission, source: :members

  has_one :owning_user, through: :ownership_permission, source: :user_or_group, source_type: 'User'
  has_one :owning_group, through: :ownership_permission, source: :user_or_group, source_type: 'Group'

  validates :name, presence: true
  validates :category, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates :ownership_permission, presence: true
  validates :price_ct, numericality: { allow_nil: true, greater_than_or_equal_to: 0 }
  enum :lend_status,
       { available: 0, lent: 1, pending_return: 2, pending_lend_request: 3, pending_pickup: 4, unavailable: 5 }
  validates :lend_status, presence: true, inclusion: { in: lend_statuses.keys }

  def price_in_euro
    unless price_ct.nil?
      ct = price_ct % 100
      euro = (price_ct - ct) / 100
      return euro, ct
    end
    [0, 0]
  end

  def set_status_available
    self.lend_status = :available
  end

  def set_status_pending_lend_request
    self.lend_status = :pending_lend_request
  end

  def set_status_lent
    self.lend_status = :lent
  end

  def set_status_pending_return
    self.lend_status = :pending_return
  end

  def set_status_pending_pickup
    self.lend_status = :pending_pickup
  end

  def set_status_unavailable
    self.lend_status = :unavailable
  end

  def deny_return
    self.lend_status = :unavailable
  end

  def price_in_euro=(euros)
    self.price_ct = euros * 100
  end

  def add_to_waitlist(user)
    waitlist.add_user(user)
  end

  def remove_from_waitlist(user)
    waitlist.remove_user(user)
  end

  def users_with_see_permission
    users_with_direct_see_permission + users_with_indirect_see_permission
  end

  def users_with_lend_permission
    users_with_direct_lend_permission + users_with_indirect_lend_permission
  end
end
