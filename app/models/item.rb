# class of a basic item.
class Item < ApplicationRecord
  has_one_attached :image
  has_one :waitlist

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

  def add_to_waitlist (user)
    #check if not owner and not allready in waitlist, should later on also check if not available
    if (!self.waitlist.users.exists?(user.id) && self.owner != user.id)
      self.waitlist.users << user
    end
  end
end
