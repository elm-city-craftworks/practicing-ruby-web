atom_feed do |feed|
  feed.title 'Practicing Ruby'
  feed.subtitle 'Delightful lessons for dedicated programmers'
  feed.updated @articles.first.published_time

  @articles.each do |article|
    feed.entry article, published: article.published_time do |entry|
      entry.title article.subject
      entry.content article.summary
      entry.summary article.summary
      entry.author do |author|
        author.name 'Practicing Ruby'
      end
    end
  end
end
