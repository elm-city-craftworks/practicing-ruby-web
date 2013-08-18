class ArticleDecorator < ApplicationDecorator
  decorates :article
  decorates_association :volume
  decorates_association :collection

  def list_description
    [ list_title,
      h.content_tag(:span, article.published_date, :class => 'right'),
      h.content_tag(:span, issue_number, :class => "issue-number")
    ].join("\n").html_safe
  end

  def list_title
    title = article.subject
    title = "[DRAFT] #{subject}" if article.status == "draft"
    title
  end

  def list_link(options={:text => list_description})
    link_text = options.delete(:text)
    path = if h.current_user
      h.article_path(article)
    else
      h.root_path
    end

    h.link_to(link_text, path, options)
  end

  def issue_number
    "Issue ##{article.issue_number}"
  end

  def published_date
    article.published_time.strftime("%B %e, %Y")
  end
end
