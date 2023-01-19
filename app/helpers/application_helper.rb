module ApplicationHelper
  include Rails.application.routes.url_helpers

  def button_to(name = nil, options = nil, html_options = nil, &block)
    new_html_options = add_class_name html_options, "btn"
    super(name, options, new_html_options, &block)
  end

  def primary_button_to(name = nil, options = nil, html_options = nil, &block)
    new_html_options = add_class_name html_options, "btn-primary"
    button_to(name, options, new_html_options, &block)
  end

  def secondary_button_to(name = nil, options = nil, html_options = nil, &block)
    new_html_options = add_class_name html_options, "btn-secondary"
    button_to(name, options, new_html_options, &block)
  end

  def add_class_name(hash, class_name)
    new_hash = hash
    new_hash ||= {}
    new_hash[:class] ||= ""
    new_hash[:class] += " #{class_name}"
    new_hash
  end

  def render_if_exists(path_to_partial, *args, &block)
    render path_to_partial, *args, &block
  rescue ActionView::MissingTemplate
    # do nothing
  end

  def language_flag(locale)
    if locale == :en
        updated_locale = :us
      else
        updated_locale = locale
      end
    content_class = "flag-icon flag-icon-#{updated_locale}"
    content_tag(:span, nil, class: content_class)
end

end
