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

    if h.current_user
      h.link_to(h.article_path(article), options) do
        link_text
      end
    else
      link_text
    end.html_safe
  end

  def issue_number
    "Issue ##{article.issue_number}"
  end

  def short_description
    article.body[0..400] + "..."
  end

  def published_date
    article.published_time.strftime("%B %e, %Y")
  end
end
