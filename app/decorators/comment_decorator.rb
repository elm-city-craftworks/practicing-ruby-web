class CommentDecorator < ApplicationDecorator
  decorates :comment
  decorates_association :user

  def time_ago
    h.time_ago_in_words comment.created_at
  end

  def controls
    if comment.editable_by? h.current_user
      [ h.link_to('Edit', '#', :class => "edit", :title => "Edit"),
        h.link_to('Delete', h.comment_path(comment),
          :class   => "remove", :title  => "Delete",
          :method  => :delete,  :remote => true,
          :confirm => "Are you sure you wish to delete this comment?")
      ].join("\n").html_safe
    end
  end

  def content
    h.md(comment.body)
  end
end