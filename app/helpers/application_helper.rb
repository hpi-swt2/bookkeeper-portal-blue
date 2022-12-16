module ApplicationHelper
  def render_if_exists(path_to_partial, *args, &block)
    render path_to_partial, *args, &block
  rescue ActionView::MissingTemplate
    # do nothing
  end
end
