module ApplicationHelper
 def full_title(page_title)
    base_title = "Disc Orders"
    if page_title.empty? or page_title.nil?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end
