module ApplicationHelper
  def display(date)  
    date.to_datetime.strftime('%B %d, %Y')
  end

  def eastern(datetime)
    datetime.in_time_zone('Eastern Time (US & Canada)')
  end
end
