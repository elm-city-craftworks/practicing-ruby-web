class << (ArticleLink = Object.new)
  include Rails.application.routes.url_helpers

  def path(article, token, params={})
    article_path(article, tokenize(token, params))
  end

  def url(article, token, params={})
    article_url(article, tokenize(token, params))
  end

  private

  def tokenize(token, params)
    {:u => token}.merge(params)
  end
end
