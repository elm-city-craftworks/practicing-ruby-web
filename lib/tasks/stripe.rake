include RakeExceptionNotification

namespace :stripe do
  desc 'Adds and updates customers active credit cards'
  task :sync_credit_cards => :environment do
    User.where(:payment_provider => 'stripe').find_each do |user|
      payment_gateway = user.payment_gateway

      stripe_card = payment_gateway.current_credit_card

      card = CreditCard.find_or_create_by_user_id(user.id)

      card.last_four        = stripe_card.last4
      card.expiration_month = stripe_card.exp_month
      card.expiration_year  = stripe_card.exp_year

      card.save
    end
  end

  desc 'Notifies customers that their credit card is about to expire'
  task :card_exipration_notice => :environment do
    exception_notify do
      CardExpirer.call(Date.today.next_month)
    end
  end
end