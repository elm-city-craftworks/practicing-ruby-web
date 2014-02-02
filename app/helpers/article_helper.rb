module ArticleHelper
  def article_url(article, params={})
    return super unless current_user && current_user.active?

    ArticleLink.new(article, params).url(current_user.share_token)
  end

  def article_path(article, params={})
    return super unless current_user && current_user.active?

    ArticleLink.new(article, params).path(current_user.share_token)
  end
end
