# class of a basic item.
# rubocop:disable Metrics/ClassLength
class Item < ApplicationRecord
  has_one_attached :image
  has_one :waitlist, dependent: :destroy
  has_many :audit_events, dependent: :destroy
  has_many :lend_request_notifications, dependent: :destroy
  has_many :return_request_notifications, dependent: :destroy
  has_many :return_accepted_notifications, dependent: :destroy
  has_many :move_up_on_waitlist_notification, dependent: :destroy
  has_many :added_to_waitlist_notification, dependent: :destroy
  has_and_belongs_to_many :users, join_table: "favorites"

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

  # Since an item `has_one :ownership_permission`, exactly one of the following attributes is set
  # the other one will be `nil`
  has_one :owning_user, through: :ownership_permission, source: :user_or_group, source_type: 'User'
  has_one :owning_group, through: :ownership_permission, source: :user_or_group, source_type: 'Group'

  validates :name, presence: true
  validates :category, presence: true
  validates :location, presence: true
  validates :ownership_permission, presence: true
  validates :price_ct, numericality: { allow_nil: true, greater_than_or_equal_to: 0 }
  validates :rental_duration_sec, numericality: { allow_nil: true, greater_than_or_equal_to: 0 }
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
    self.rental_start = Time.now.utc
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

  def accept_return
    reset_status
    return if waitlist.users.empty?

    @new_borrower = waitlist.first_user
    waitlist.remove_user(@new_borrower)
    @owner = owning_user
    @lend_notification = LendRequestNotification.new(item: self, borrower: @new_borrower, receiver: @owner,
                                                     date: Time.zone.now, unread: true, active: true)
    @lend_notification.save
    set_status_pending_lend_request
  end

  def deny_return
    self.lend_status = :unavailable
  end

  def price_in_euro=(euros)
    self.price_ct = euros * 100
  end

  def reset_status
    self.rental_start = nil
    self.holder = nil
    set_status_available
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

  def users_with_ownership_permission
    if owning_user.nil?
      owning_group.members
    else
      [owning_user]
    end
  end

  def set_rental_start_time
    self.rental_start = Time.now.utc
  end

  def status_pending_pickup?
    lend_status == "pending_pickup"
  end

  def perform_pickup_check
    return unless status_pending_pickup?

    job = Job.find_by(item: self)
    job.destroy
    reset_status
    save
  end

  def rental_end
    return Time.now.utc if rental_start.nil? || rental_duration_sec.nil?

    rental_start + rental_duration_sec
  end

  def remaining_rental_duration
    rental_end - Time.now.utc
  end

  def print_remaining_rental_duration
    print_time_from_seconds(remaining_rental_duration)
  end

  def print_time_from_seconds(seconds)
    if seconds.negative?
      I18n.t("views.dashboard.lent_items.expired", date: rental_end.strftime("%d.%m.%Y"))
    elsif seconds < 86_400
      I18n.t "views.dashboard.lent_items.today"
    elsif seconds < 7 * 86_400
      I18n.t("views.dashboard.lent_items.days", count: (seconds / 86_400).to_i)
    else
      I18n.t("views.dashboard.lent_items.weeks", count: (seconds / (7 * 86_400)).to_i)
    end
  end

  def progress_lent_time
    return 100 if rental_start.nil? || rental_duration_sec.nil? || rental_duration_sec.zero?

    lent_time_progress = (((rental_duration_sec - remaining_rental_duration) * 100) / rental_duration_sec).to_i
    if lent_time_progress.negative?
      0
    elsif lent_time_progress > 100
      100
    else
      lent_time_progress
    end
  end
end
# rubocop:enable Metrics/ClassLength
