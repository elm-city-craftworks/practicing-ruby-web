class ArticleDecorator < ApplicationDecorator
  decorates :article

  def body
    fetch_article_from_repo || article.body
  end

  private

  def fetch_article_from_repo
    ArticleRepo.file(article.path).try(:raw_data)
  end
end
