module SearchHelper
  # search_term: you are looking for relevant search attributes, partially matching search.
  # Currently results include items where all words of the search term appear in at least
  # one of the relevant search attributes.
  #
  # filter_category: filter search results with a hash in the form:
  # {"filter_name_a" => "filter_value_a", "filter_name_b" => "filter_value_b"}.
  # filter_numerical: filter search by numerial range in the form:
  # {"search_name" => {"lower_bound" => 8, "upper_bound" => 10}, ...}
  def search_for_items(search_term, filter_category = {}, filter_numerical = {})
    return [] if search_term.blank?

    sql_where_clause = generate_sql_where_clause(search_term, filter_category, filter_numerical)
    Item.where(sql_where_clause)
  end

  private

  # returns LIKE partial matching search
  def create_sql_like(search_attribute, search_term)
    "#{search_attribute} LIKE '%#{Item.sanitize_sql_like(search_term)}%'"
  end

  def create_sql_like_one_search_term(search_term)
    relevant_search_attributes.map { |attribute| create_sql_like(attribute, search_term) }.join(" OR ")
  end

  def create_sql_like_multiple_search_terms(search_terms)
    like_clause = search_terms.map { |term| create_sql_like_one_search_term(term) }.join(') AND (')
    "(#{like_clause})"
  end

  # retuns equals expression for filter
  def create_sql_equal(search_attribute, search_value)
    "#{search_attribute} = '#{search_value}'"
  end

  def create_sql_lower_upper(search_attribute, lower_bound, upper_bound)
    "#{search_attribute} BETWEEN #{lower_bound} AND #{upper_bound}"
  end

  def relevant_search_attributes
    [:name, :description]
  end

  def generate_sql_where_clause(search_term, filter_category = {}, filter_numerical = {})
    # split search term by words into list.
    search_terms = search_term.split
    # for each word and attribute create like, equal and between clause. Disjuncts attributes and conjucts search_terms.
    sql_like_clause = create_sql_like_multiple_search_terms(search_terms)
    sql_equal_clause = filter_category.map { |key, value| create_sql_equal(key, value) }.join(" AND ")
    sql_between_clause = filter_numerical.map do |key, bounds|
      create_sql_lower_upper(key, bounds["lower_bound"], bounds["upper_bound"])
    end.join(" AND ")
    [sql_like_clause, sql_equal_clause, sql_between_clause].reject(&:empty?).map do |clause|
      "(#{clause})"
    end.join(" AND ")
  end
end
