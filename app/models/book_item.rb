# class of a BookItem.
class BookItem < Item
  validates :page_count, numericality: { greater_than_or_equal_to: 0 }
  validates :genre, presence: true
  validates :author, presence: true
  validates :movie_duration, :player_count, absence: true

  def custom_subclass_attributes
    [:author, :genre, :page_count]
  end
end
