# class of a MovieItem.
class MovieItem < Item
  validates :movie_duration, numericality: { greater_than_or_equal_to: 0 }
  validates :genre, presence: true
  validates :author, :page_count, :player_count, absence: true

  def custom_subclass_attributes
    [:genre, :movie_duration]
  end
end
