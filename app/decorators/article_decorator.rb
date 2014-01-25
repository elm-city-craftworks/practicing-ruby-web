class ArticleDecorator < ApplicationDecorator
  decorates :article
  decorates_association :volume
  decorates_association :collection

  def list_title
    title = article.subject
    if article.status == "draft"
      title = "[DRAFT] #{subject}"
    elsif article.status == "published" && (h.current_user.nil? || !h.current_user.active?)
      title = "[Subscriber Only] #{subject}"
    end
    title
  end

  def list_link(options={:text => list_title})
    link_text = options.delete(:text)
    path = if h.current_user
      h.article_path(article)
    else
      h.root_path
    end

    h.link_to(link_text, path, options)
  end

  def issue_number
    "Issue #{article.issue_number}"
  end

  def published_date
    article.published_time.strftime("%B %e, %Y")
  end
end
