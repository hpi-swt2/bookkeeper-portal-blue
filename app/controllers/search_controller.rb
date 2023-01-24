class SearchController < ApplicationController
  def index
    search_term = params[:search]

    @order_options = [[t('views.search.order.default'), 0],
                      [t('views.search.order.popularity'), 1],
                      [t('views.search.order.name_a_z'), 2],
                      [t('views.search.order.name_z_a'), 3]]

    @results = helpers.search_for_items(search_term)
  end
end
