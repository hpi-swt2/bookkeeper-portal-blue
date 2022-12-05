module SearchHelper
  # search_term: you are looking for relevant search attributes, partially matching search.
  # Currently results include items where all words of the search term appear in at least
  # one of the relevant search attributes.
  #
  # filter_category: filter search results with a hash in the form:
  # {"filter_name_a" => "filter_value_a", "filter_name_b" => "filter_value_b"}.
  #
  # filter_numerical: filter search by numerial range in the form:
  # {"search_name" => {"lower_bound" => 8, "upper_bound" => 10}, ...}
  def search_for_items(search_term, filter_category = {}, filter_numerical = {})
    return [] if search_term.blank?

    partial_matching_clause = create_partial_matching_clause(search_term)
    categorial_attribute_clause = create_mutiple_categorial_attribute_clause(filter_category)
    numerical_attribute_clause = create_mutiple_numerical_attribute_clause(filter_numerical)

    Item.where(partial_matching_clause)
        .where(categorial_attribute_clause)
        .where(numerical_attribute_clause)
  end

  private

  # CREATE CLAUSE FOR PARTIAL MATCHING

  def create_partial_matching_attribute_term(search_attribute, search_term)
    "#{search_attribute} LIKE '%#{Item.sanitize_sql_like(search_term)}%'"
  end

  def create_partial_matching_one_search_term(search_term)
    clauses = relevant_search_attributes.map do |attribute|
      create_partial_matching_attribute_term(attribute, search_term)
    end
    clauses.join(" OR ")
  end

  def create_partial_matching_clause(search_term)
    search_terms = search_term.split
    clauses = search_terms.map { |term| create_partial_matching_one_search_term(term) }
    clauses.map { |clause| "(#{clause})" }.join(' AND ')
  end

  # CREATE CLAUSE FOR CATEGORIAL ATTRIBUTE

  def create_single_categorial_attribute_clause(search_attribute, filter_category)
    return "" unless filter_category.key?(search_attribute)

    search_value = filter_category[search_attribute]
    "#{search_attribute} = '#{search_value}'"
  end

  def create_mutiple_categorial_attribute_clause(filter_category)
    clauses = relevant_categorial_attribute.map do |attribute|
      create_single_categorial_attribute_clause(attribute, filter_category)
    end
    filtered_clauses = clauses.compact_blank
    filtered_clauses.map { |clause| "(#{clause})" }.join(' AND ')
  end

  # CREATE CLAUSE FOR NUMERICAL ATTRIBUTE

  def create_single_numerical_attribute_clause(search_attribute, filter_numerical)
    return "" unless filter_numerical.key?(search_attribute)

    bounds = filter_numerical[search_attribute]
    lower_bound = bounds["lower_bound"]
    upper_bound = bounds["upper_bound"]
    "#{search_attribute} BETWEEN #{lower_bound} AND #{upper_bound}"
  end

  def create_mutiple_numerical_attribute_clause(filter_numerical)
    clauses = relevant_numerical_attribute.map do |attribute|
      create_single_numerical_attribute_clause(attribute, filter_numerical)
    end
    filtered_clauses = clauses.compact_blank
    filtered_clauses.map { |clause| "(#{clause})" }.join(' AND ')
  end

  # CONSTANTS

  def relevant_search_attributes
    %w[name description]
  end

  def relevant_categorial_attribute
    %w[category]
  end

  def relevant_numerical_attribute
    %w[price_ct]
  end
end
