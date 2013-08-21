class << (ArticleLink = Object.new)
  include Rails.application.routes.url_helpers

  def path(article, token, params={})
    article_path(article, {:u => token}.merge(params))
  end

  def url(*args)
    "https://practicingruby.com#{path(*args)}"
  end
end
