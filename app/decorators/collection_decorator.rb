class CollectionDecorator < ApplicationDecorator
  decorates :collection

  def header
    h.content_tag(:div, :class => 'collection') do
      [ icon, collection.name ].join("\n").html_safe
    end.html_safe
  end

  def icon
    h.content_tag(:span, h.image_tag("icons/#{collection.image_file_name}"), :class => 'icon')
  end

  def path
    h.collection_path(collection.slug)
  end
end