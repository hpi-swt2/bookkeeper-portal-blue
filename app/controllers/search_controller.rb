class SearchController < ApplicationController
  def index
    @results = ["SAP S/4HANA", "Erstifilm", "Coffee"]
  end
end
