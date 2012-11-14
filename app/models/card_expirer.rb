CardExpirer = ->(date) {
  cards = CreditCard.where(:expiration_year  => date.year,
                           :expiration_month => date.month )
  cards.each do |card|
    AccountMailer.card_expiring(card)
  end
}