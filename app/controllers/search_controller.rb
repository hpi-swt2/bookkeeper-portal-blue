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
      else
        sort_results_by_popularity(unsorted_results)
      end
  end

  def sort_results_by_popularity(unsorted_results)
    sorted_by_popularity = helpers.statistics_sort_items_by_popularity(unsorted_results)
    # rubys `sort_by` is unstable. By adding the index as a second key the search is stabilized
    sorted_by_popularity.each_with_index.sort_by do |item, index|
      [item.lend_status, index]
    end.map(&:first)
  end
end
