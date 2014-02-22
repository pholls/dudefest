module ApplicationHelper
  def display(date)  
    date.to_datetime.strftime('%B %d, %Y')
  end

  def eastern(datetime)
    datetime.in_time_zone('Eastern Time (US & Canada)')
  end

  def display_datetime(datetime)
    eastern(datetime).strftime('%m-%d-%Y | %l:%M %p')
  end

  def meta_keywords(tags = nil)
    if tags.present?
      content_for :meta_keywords, tags
    elsif content_for?(:meta_keywords) 
      [content_for(:meta_keywords), APP_CONFIG['meta_keywords']].join(', ') 
    else 
      APP_CONFIG['meta_keywords']
    end
  end

  def meta_description(desc = nil)
    if desc.present?
      content_for :meta_description, desc
    elsif content_for?(:meta_description) 
      content_for(:meta_description) 
    else
      APP_CONFIG['meta_description']
    end
  end
end
