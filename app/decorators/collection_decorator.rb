class CollectionDecorator < Draper::Decorator
  delegate_all

  def self.icon(name)
    h.content_tag(:span,
      h.image_tag("icons/#{name}"),
      :class => 'icon collection'
    )
  end

  def header
    h.content_tag(:div, :class => 'collection') do
      [ icon, collection.name ].join("\n").html_safe
    end.html_safe
  end

  def icon
    self.class.icon(collection.image_file_name)
  end

  def path
    h.collection_path(collection.slug)
  end
end
