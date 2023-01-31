class SearchController < ApplicationController
  def index
    setup_variables

    create_availability_filter
    create_category_filters

    unsorted_results = helpers.search_for_items(params[:search], @filters, @numerical_filters, params[:group].to_i)
    sort_results(params[:order], unsorted_results)
  end

  private

  def setup_variables
    @availability_options = [[t('views.search.filter_modal.available'), 0],
                             [t('views.search.filter_modal.unavailable'), 1]]

    @category_options = Item.valid_types.keys.map { |type| [t("models.item.types.#{type.underscore}"), type] }

    @order_options = [[t('views.search.order.popularity'), 0],
                      [t('views.search.order.name_a_z'), 1],
                      [t('views.search.order.name_z_a'), 2]]

    @group_options = Group.select(:name).pluck(:name, :id)
  end

  def create_category_filters
    @filters = {}

    return if params[:type].blank?

    @filters["type"] = params[:type]
  end

  def create_availability_filter
    @numerical_filters = {}
    availability = params[:availability]

    return if availability.blank? || availability.to_i > 1 || availability.to_i.negative?

    avail = availability.to_i

    @numerical_filters["lend_status"] = if avail.zero?
                                          { "lower_bound" => 0, "upper_bound" => 0 }
                                        else
                                          { "lower_bound" => 1, "upper_bound" => 5 }
                                        end
  end

  def sort_results(order, unsorted_results)
    @results =
      case order
      when "1"
        unsorted_results.order(name: :asc, lend_status: :asc)
      when "2"
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
