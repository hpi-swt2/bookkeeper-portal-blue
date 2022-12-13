# class of a basic item.
class Item < ApplicationRecord
  has_one_attached :image
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

  def price_in_euro=(euros)
    self.price_ct = euros * 100
  end
end
