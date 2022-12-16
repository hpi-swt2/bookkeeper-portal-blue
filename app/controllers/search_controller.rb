class SearchController < ApplicationController
  def index
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
