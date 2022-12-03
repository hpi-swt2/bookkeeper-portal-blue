# class of a basic item.
class Item < ApplicationRecord
  has_one_attached :image
  has_and_belongs_to_many :users

  validates :name, presence: true
  validates :category, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates :owner, presence: true

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
end
