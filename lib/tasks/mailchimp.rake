include ActionView::Helpers::TextHelper
include RakeExceptionNotification

namespace :mailchimp do
  desc 'Disable accounts which have been unsubscribed in mailchimp'
  task :disable_unsubscribed => :environment do

    puts "== Running mailchip:update_subscribers at #{Time.now} =="

    exception_notify do
      user_manager = UserManager.new
      user_manager.disable_unsubscribed_users

      raise "Wow"
    end
  end
end