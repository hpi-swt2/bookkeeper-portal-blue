class SearchController < ApplicationController
  def index
    setup_variables

    @search_term = params[:search]
    @availability = params[:availability]
    @category = params[:category]
    order = params[:order]

    create_availability_filter
    create_category_filters

    unsorted_results = helpers.search_for_items(@search_term, @filters, @numerical_filters)
    sort_results(order, unsorted_results)
  end

  private

  def setup_variables
    @availability_options = [[t('views.search.filter_modal.available'), 0],
                             [t('views.search.filter_modal.unavailable'), 1]]

    @category_options = Item.select(:category).distinct.pluck(:category)

    @order_options = [[t('views.search.order.popularity'), 0],
                      [t('views.search.order.name_a_z'), 1],
                      [t('views.search.order.name_z_a'), 2]]
  end

  def create_availability_filter
    availability = @availability
    @numerical_filters = {}

    return if availability.blank? || availability.to_i > 1 || availability.to_i.negative?

    avail = availability.to_i

    @numerical_filters["lend_status"] = if avail.zero?
                                          { "lower_bound" => 0, "upper_bound" => 0 }
                                        else
                                          { "lower_bound" => 1, "upper_bound" => 5 }
                                        end
  end

  def create_category_filters
    @filters = {}

    return if @category.blank?

    @filters["category"] = @category
  end

  def sort_results(order, unsorted_results)
    @results =
      case order
      when "1"
        unsorted_results.order(name: :asc, lend_status: :asc)
      when "2"
        unsorted_results.order(name: :desc, lend_status: :asc)
      else # add popularity sort here
        unsorted_results.order(lend_status: :asc)
      end
  end
end
