module ApplicationHelper

  # Title not provided helper
  def title
    base_title = "Squarker"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  #Add logo helper
  def logo
    image_tag("logo.png", :alt => "Logo Image", :class => "round")
  end

end