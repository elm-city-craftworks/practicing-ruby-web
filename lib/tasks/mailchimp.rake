include ActionView::Helpers::TextHelper

namespace :mailchimp do
  desc 'Update subscribers with mailchimp'
  task :update_subscribers => :environment do

    puts "== Running mailchip:update_subscribers at #{Time.now} =="

    api = MailChimp::Api.new

    unsubscribed = api.unsubscribed_users.map {|u| u["email"] }

    puts "#{pluralize(unsubscribed.count, 'user is', 'users are')} currently " +
         "unsubscribed in MailChimp"

    disabled_users = User.where(:email => unsubscribed).each do |user|
      user.disable
    end

    deleted_users = unsubscribed.each do |email|
      api.delete_user(email)
    end

    puts "#{pluralize(disabled_users.count, 'user was', 'users were')} " +
         "disabled in Practicing Ruby and " +
         "#{pluralize(deleted_users.count, 'user was', 'users were')} " +
         "deleted in MailChimp"
  end
end