class SearchController < ApplicationController
  def index
    @results = ["SAP S/4HANA", "Erstifilm mit viel zu langem Titel für die Card", "Coffee"]
  end
end
