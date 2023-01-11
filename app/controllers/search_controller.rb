class SearchController < ApplicationController
  def index
    @avalability_options = [["unavailable", 0], ["available", 1]]
    @category_options = Item.select(:category).distinct.pluck(:category)

    search_term = params[:search]
    if search_term.blank?
      @lastsearch = params[:lastsearch]
      search_term = @lastsearch
    else
      @lastsearch = search_term
    end
    @results = helpers.search_for_items(search_term)
  end
end
