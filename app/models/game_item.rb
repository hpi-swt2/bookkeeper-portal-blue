class GameItem < Item
  validates :player_count, numericality: { greater_than_or_equal_to: 0 }
  validates :title, :author, presence: true
  validates :genre, :movie_duration, :page_count, absence: true
end
