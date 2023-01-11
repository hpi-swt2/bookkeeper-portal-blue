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
    parse_filters

    @results = helpers.search_for_items(search_term, @filters)
  end

  private

  def setup_variables
    @availability_options = [[t('views.search.filter_modal.available'), 0],
                             [t('views.search.filter_modal.unavailable'), 1]]
    @category_options = Item.select(:category).distinct.pluck(:category)
  end

  def parse_filters
    availability = params[:availability]
    category = params[:category]

    @filters = {}

    if availability.present? && availability.to_i <= 1 && availability.to_i >= 0
      @filters[:lend_status] = availability.to_i
    end

    return if category.blank?

    @filters[:category] = category
  end
end
