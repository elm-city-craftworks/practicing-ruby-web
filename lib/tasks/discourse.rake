desc 'Generates discourse topics for articles missing discourse urls'
task generate_discourse_topics: :environment do
  DISCOURSE_URL = "http://discourse.practicingruby.com/".freeze

  articles = Article.where(discourse_url: nil)
  topics = []

  articles.find_each do |article|
    article_url = Rails.application.routes.url_helpers.article_url(article)

    topic = {
      category: "Published Works",
      skip_validations: true,
      auto_track: false,
      title: article.full_subject,
      raw: "_#{article.summary}_\n\n" +
        "[Read the article on practicingruby.com](#{article_url}), " +
        "discuss here!",
      article_id: article.id
    }

    if article.comments.any?
      post_text = []

      article.comments.each do |comment|
        post_text << "\n---\n\n__Imported comment from " +
        "@#{comment.user.github_nickname}, posted on " +
        "#{comment.created_at.strftime('%Y-%m-%d')}__\n\n---\n" +
        "#{comment.body}\n"
      end

      post_text << "\n\n(via practicingruby.com's now-defunct commenting system)"

      topic[:post] = post_text.join
    end

    topics << topic
  end

  File.write('topics.json', topics.to_json)
end

desc 'Load discourse urls into articles'
task load_discourse_urls: :environment do
  urls = JSON.parse(File.read('discourse_urls.json'))

  urls.each do |article_id, url|
    article = Article.find(article_id)

    article.discourse_url = url
    article.save
  end
end
