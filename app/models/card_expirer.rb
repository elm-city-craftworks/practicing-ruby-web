CardExpirer = ->(date) {
  cards = CreditCard.includes(:user)
                    .where(:expiration_year  => date.year,
                           :expiration_month => date.month,
                           "users.status"    => "active")
  cards.each do |card|
    AccountMailer.card_expiring(card)
  end
}
