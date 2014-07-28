module ApplicationHelper
  # Returns the full title on a per-page basis
  def full_title(page_title)
    base_title = "Project Tiny"
    title_divider = "|"
    if page_title.empty?
      base_title
    else
      "#{base_title} #{title_divider} #{page_title}"
    end
  end
end
