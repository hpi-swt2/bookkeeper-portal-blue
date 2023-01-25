class MovieItem < Item
  validates :movie_duration, numericality: { greater_than_or_equal_to: 0 }
  validates :title, presence: true
  validates :genre, presence: true
  validates :author, :page_count, :player_count, absence: true
end
