module ApplicationHelper
  BASE_TITLE = "The Game of Life"
  def config_title(title)
    if title.empty?
      BASE_TITLE
    else
      "#{BASE_TITLE} | #{title}"
    end
  end
end
