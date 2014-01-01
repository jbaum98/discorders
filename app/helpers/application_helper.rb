module ApplicationHelper
 def full_title(page_title)
    base_title = "Disc Orders"
    if page_title.empty? or page_title.nil?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def minify_include(resource)
    name, extension = resource.split('.')
    if Rails.env.development?
      return javascript_include_tag resource if extension == 'js'
      return stylesheet_link_tag resource if extension == 'css'
    else
      return javascript_include_tag "#{name}.min.#{extension}" if extension == 'js'
      return stylesheet_link_tag "#{name}.min.#{extension}" if extension == 'css'
    end
  end
end
