# class of a GameItem.
class GameItem < Item
  validates :player_count, numericality: { greater_than_or_equal_to: 0 }
  validates :author, presence: true
  validates :genre, :movie_duration, :page_count, absence: true

  def custom_subclass_attributes
    [:author, :player_count]
  end
end
