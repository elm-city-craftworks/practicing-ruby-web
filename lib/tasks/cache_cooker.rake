# Rake tasks to bake caches
#
namespace :bake do
  desc 'Refresh the articles cache'
  task :articles => :environment do
    puts "Fire up the oven. It's time to start cookin!"

    Article.order("published_time DESC").each do |article|
      CacheCooker.bake("/articles/#{article.id}")
    end

    puts "#{Article.count} articles baked and ready to serve :)"
  end
end