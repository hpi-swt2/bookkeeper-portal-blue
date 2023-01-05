# class of a basic item.
class Item < ApplicationRecord
  has_one_attached :image
  has_one :waitlist, dependent: :destroy
  has_many :lend_request_notifications, dependent: :destroy
  has_many :return_request_notifications, dependent: :destroy
  has_many :return_accepted_notifications, dependent: :destroy
  has_many :move_up_on_waitlist_notification, dependent: :destroy
  has_many :added_to_waitlist_notification, dependent: :destroy
  has_and_belongs_to_many :users, join_table: "wishlist"

  validates :name, presence: true
  validates :category, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates :owner, presence: true
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

  def price_in_euro=(euros)
    self.price_ct = euros * 100
  end

  def reset_status
    self.rental_start = nil
    self.rental_duration_sec = nil
    self.holder = nil
    set_status_available
  end

  def add_to_waitlist(user)
    waitlist.add_user(user)
  end

  def remove_from_waitlist(user)
    waitlist.remove_user(user)
  end

  def rental_end
    rental_start + rental_duration_sec
  end

  def remaining_rental_duration
    rental_end - Time.now.utc
  end

  def progress_lent_time
    lent_time_progress = (((rental_duration_sec - remaining_rental_duration) * 100) / rental_duration_sec).to_i
    if lent_time_progress.negative?
      0
    else
      lent_time_progress
    end
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
end
