# class of a basic item.
class Item < ApplicationRecord
  has_one_attached :image
  has_and_belongs_to_many :users, join_table: "wishlist"

  validates :name, presence: true
  validates :category, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates :owner, presence: true
  validates :price_ct, numericality: { allow_nil: true, greater_than_or_equal_to: 0 }

  def price_in_euro
    unless price_ct.nil?
      ct = price_ct % 100
      euro = (price_ct - ct) / 100
      return euro, ct
    end

    [0, 0]
  end

  def price_in_euro=(euros)
    self.price_ct = euros * 100
  end

  def rental_end
    rental_start + rental_duration_sec
  end

  def remaining_rental_duration
    humanize(rental_end - Time.now(in: "UTC"))
  end

  def humanize(secs)
    if secs > 0
      humanizeHElP(secs)
    else
      humanizeHElP(secs * -1).prepend("-")
    end
  end

  def humanizeHElP(secs)
      [[60, :s], [60, :m], [24, :h], [Float::INFINITY, :d]].map{ |count, name|
        secs, n = secs.divmod(count)
        "#{n.to_i} #{name}" unless n.to_i==0
      }.compact.reverse.join(' ')
  end
end
