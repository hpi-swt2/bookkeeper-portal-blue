# class of a basic item.
class Item < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true
  validates :category, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates :owner, presence: true
  validates :price_ct, numericality: { allow_nil: true, greater_than_or_equal_to: 0 }
  validates :lend_status, presence: true, numericality: { only_integer: true, in: 0..2 }
  enum :lend_status, { available: 0, lent: 1, pending_return: 2 }


  def price_in_euro
    unless price_ct.nil?
      ct = price_ct % 100
      euro = (price_ct - ct) / 100
      return euro, ct
    end

    [0, 0]
  end
  
  def request_return
    # TODO send request return notification to owner with holder information
    self.lend_status = :pending_return
  end

  def stop_lending
    self.rental_start = nil
    self.rental_duration_sec = nil
    self.holder = nil
    self.lend_status = :available
  end

  def price_in_euro=(euros)
    self.price_ct = euros * 100
  end
end
