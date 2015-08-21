require 'discourse_api'
require 'json'
require 'pry'

DISCOURSE_URL = "http://discourse.practicingruby.com/".freeze

topics = JSON.parse(File.read('topics.json'))

client = DiscourseApi::Client.new(DISCOURSE_URL)
client.api_key      = ENV['DISCOURSE_API_KEY']
client.api_username = ENV['DISCOURSE_USERNAME']

discourse_urls = {}

topics.each do |topic|
  post       = topic.delete('post')
  article_id = topic.delete('article_id')

  topic = Hash[*topic.map {|k,v| [k.to_sym, v] }.flatten]

  discourse_topic = client.create_topic(topic)

  topic_id   = discourse_topic['topic_id']
  topic_slug = discourse_topic['topic_slug']

  discourse_url = DISCOURSE_URL + "t/#{topic_slug}/#{topic_id}"


  if post
    client.create_post(topic_id: topic_id, raw: post)
  end

  discourse_urls[article_id] = discourse_url

  puts discourse_url
  sleep 2
end

File.write('discourse_urls.json', discourse_urls.to_json)
