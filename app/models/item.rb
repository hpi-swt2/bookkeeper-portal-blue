# class of a basic item.
class Item < ApplicationRecord
  has_one_attached :image
  has_one :waitlist, dependent: :destroy
  has_many :lend_request_notifications, dependent: :destroy
  has_and_belongs_to_many :users, join_table: "wishlist"

  validates :name, presence: true
  validates :category, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates :owner, presence: true
  validates :price_ct, numericality: { allow_nil: true, greater_than_or_equal_to: 0 }
  enum :lend_status, { available: 0, lent: 1, pending_return: 2 }
  validates :lend_status, presence: true, inclusion: { in: lend_statuses.keys }

  def price_in_euro
    unless price_ct.nil?
      ct = price_ct % 100
      euro = (price_ct - ct) / 100
      return euro, ct
    end

    [0, 0]
  end

  def request_return
    # TODO: send request return notification to owner with holder information
    self.lend_status = :pending_return
  end

  def accept_return
    self.rental_start = nil
    self.rental_duration_sec = nil
    self.holder = nil
    self.lend_status = :available
  end

  def deny_return
    # TODO
  end

  def set_status_lent
    self.lend_status = :lent
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

  def rental_end
    rental_start + rental_duration_sec
  end

  def remaining_rental_duration
    rental_end - Time.now.utc
  end

  def print_remaining_rental_duration
    print_time_from_seconds(remaining_rental_duration)
  end

  def print_time_from_seconds(seconds)
    if seconds.positive?
      humanize(seconds)
    else
      humanize(seconds * -1).prepend("-")
    end
  end

  def humanize(seconds)
    [[60, :s], [60, :m], [24, :h], [Float::INFINITY, :d]].filter_map do |count, name|
      seconds, n = seconds.divmod(count)
      "#{n.to_i} #{name}" unless n.to_i.zero?
    end.reverse.join(' ')
  end
end
