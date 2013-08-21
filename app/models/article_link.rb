class ArticleLink
  include Rails.application.routes.url_helpers

  def initialize(article, params)
    self.article = article
    self.params  = params
  end

  def path(token)
    article_path(article, params_with_token(token))
  end

  def url(token)
    article_url(article, params_with_token(token))
  end

  private

  attr_accessor :params, :article

  def params_with_token(token)
    {:u => token}.merge(params)
  end
end
