class OtherItem < Item
  validates :title, :author, :genre, :page_count, :movie_duration, :player_count, absence: true
end
