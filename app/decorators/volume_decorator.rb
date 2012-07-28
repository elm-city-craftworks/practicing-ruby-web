class VolumeDecorator < ApplicationDecorator
  decorates :volume

  def header
    h.content_tag(:div, :class => 'volume') do
      [ icon, volume.name ].join("\n").html_safe
    end.html_safe
  end

  def icon
    h.content_tag(:span, volume.number, :class => 'icon')
  end

  def path
    h.articles_path(:volume => volume.number)
  end

  def publish_range
    if volume.articles.published.empty? || volume.start_date.nil?
      "Coming Soon ..."
    else
      date_format = "%B %Y"

      [
        volume.start_date.strftime(date_format),
        volume.end_date.strftime(date_format)
      ].join(" - ")
    end
  end
end