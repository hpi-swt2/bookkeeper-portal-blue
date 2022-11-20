class Item < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true
  validates :category, presence: true
  validates :location, presence: true
  validates :description, presence: true

  def price_in_euro
    if(price_ct != nil)
      ct = price_ct%100
      euro = (price_ct-ct)/100

      return euro, ct
    end

    return 0,0

  end

  def price_in_euro=(euros)
    self.price_ct = euros*100
  end

end
