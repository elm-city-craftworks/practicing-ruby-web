# Rake tasks to bake caches
#
namespace :bake do
  desc 'Refresh the articles cache'
  task :articles => :environment do
    Article.find_each do |article|
      CacheCooker.bake("/articles/#{article.id}")
    end

    puts "#{Article.count} articles baked and ready to serve :)"
  end
end