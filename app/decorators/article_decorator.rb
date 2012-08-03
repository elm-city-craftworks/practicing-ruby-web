class ArticleDecorator < ApplicationDecorator
  decorates :article
  decorates_association :volume
  decorates_association :collection

  def list_description
    subject = article.subject
    subject = "[DRAFT] #{subject}" if article.status == "draft"

    [ subject,
      h.content_tag(:span, article.published_date, :class => 'right'),
      h.content_tag(:span, "Issue ##{article.issue_number}", :class => "issue-number")
    ].join("\n").html_safe
  end

  def list_link
    if h.current_user
      h.link_to(h.article_path(article)) do
        list_description
      end
    else
      list_description
    end.html_safe
  end

  def published_date
    article.published_time.strftime("%B %e, %Y")
  end
end