class SearchController < ApplicationController
  def index
    setup_variables

    search_term = params[:search]
    if search_term.blank?
      @lastsearch = params[:lastsearch]
      search_term = @lastsearch
    else
      @lastsearch = search_term
    end
    @results = helpers.search_for_items(search_term)
  end

  private

  def setup_variables
    @availability_options = [[t('views.search.filter_modal.available'), 0],
                             [t('views.search.filter_modal.unavailable'), 1]]
    @category_options = Item.select(:category).distinct.pluck(:category)
  end
end
