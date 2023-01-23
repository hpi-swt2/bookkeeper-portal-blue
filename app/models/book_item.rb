class BookItem < Item
  validates :page_count, numericality: { greater_than_or_equal_to: 0 }
  validates :title, presence: true
  validates :genre, presence: true
  validates :author, presence: true
end
