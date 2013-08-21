module ApplicationHelper
  def article_url(article, params={})
    return super unless current_user

    ArticleLink.new(article, params).url(current_user.share_token)
  end

  def article_path(article, params={})
    return super unless current_user

    ArticleLink.new(article, params).path(current_user.share_token)
  end

  def home_path
    if current_user
      library_path
    else
      root_path
    end
  end

  def md(content)
    MdPreview::Parser.parse(content)
  end

  def beta_testers
    yield if current_user.try(:beta_tester)
  end

  def error_messages_for(object)
    if object.errors.any?
      content_tag(:div, :id => "errorExplanation") do
        content_tag(:h2) { "Whoops, looks like something went wrong." } +
        content_tag(:p) { "Please review the form below and make the appropriate changes." } +
        content_tag(:ul) do
          object.errors.full_messages.map do |msg|
            content_tag(:li) { msg }
          end.join("\n").html_safe
        end
      end
    end
  end
end
