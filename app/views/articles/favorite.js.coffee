articleId = <%= @article.id %>

$("a.favorite-link[data-article-id=#{articleId}]").toggleClass('favorited')
