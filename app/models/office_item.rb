# class of an OtherItem.
class OfficeItem < Item
  validates :title, :author, :genre, :page_count, :movie_duration, :player_count, absence: true

  def custom_subclass_attributes
    []
  end
end
