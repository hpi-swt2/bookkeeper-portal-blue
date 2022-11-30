class SearchController < ApplicationController
  def index
    @results = Item.all
  end
end
