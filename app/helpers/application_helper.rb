module ApplicationHelper
  def render_if_exists(path_to_partial, *args, &block)
    begin
      render path_to_partial, *args, &block
    rescue ActionView::MissingTemplate
      # do nothing
    end
  end
end
