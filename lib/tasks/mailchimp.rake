include ActionView::Helpers::TextHelper

namespace :mailchimp do
  desc 'Disable accounts which have been unsubscribed in mailchimp'
  task :disable_unsubscribed => :environment do

    puts "== Running mailchip:update_subscribers at #{Time.now} =="

    user_manager = UserManager.new

    user_manager.disable_unsubscribed_users
  end
end