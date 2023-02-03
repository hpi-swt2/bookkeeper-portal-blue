# class of an OfficeItem.
class OfficeItem < Item
  validates :author, :genre, :page_count, :movie_duration, :player_count, absence: true

  def custom_subclass_attributes
    []
  end
end
