class SearchController < ApplicationController
  def index
    search_term = params[:search]

    @order_options = [[t('views.search.order.default'), 0],
                      [t('views.search.order.popularity'), 1],
                      [t('views.search.order.name_a_z'), 2],
                      [t('views.search.order.name_z_a'), 3]]

    order = params[:order]
    unsorted_results = helpers.search_for_items(search_term)
    sort_results(order, unsorted_results)
  end

  private

  def sort_results(order, unsorted_results)
    @results =
      case order
      when "2"
        unsorted_results.order(name: :asc, lend_status: :asc)
      when "3"
        unsorted_results.order(name: :desc, lend_status: :asc)
      else # add popularity sort here
        unsorted_results.order(lend_status: :asc)
      end
  end
end
