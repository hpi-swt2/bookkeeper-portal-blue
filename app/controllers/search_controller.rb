class SearchController < ApplicationController
  def index
    search_term = params[:search]  
    @results = helpers.search_for_items(search_term)
  end
end
