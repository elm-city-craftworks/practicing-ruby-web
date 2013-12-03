module PaymentGateway
  class Stripe

    def self.for_customer(customer_id)
      user = User.where(
        :payment_provider    => 'stripe',
        :payment_provider_id => customer_id
      ).first

      new user if user
    end

    def initialize(user)
      @user            = user
      ::Stripe.api_key = STRIPE_SECRET_KEY
    end

    def coupon_valid?(coupon)
      return true if coupon.blank?

      begin
        !!::Stripe::Coupon.retrieve(coupon)
      rescue ::Stripe::InvalidRequestError => e
        false
      end
    end

    def subscribe(params = {})
      token  = params[:stripeToken]
      coupon = params[:coupon]

      if customer = find_customer
        update_credit_card(params)
      else
        customer = create_customer(token)
      end

      save_credit_card(customer.active_card)

      subscription_options = { :plan => find_plan(params[:interval]) }
      subscription_options[:coupon] = coupon unless coupon.blank?

      subscription = customer.update_subscription(subscription_options)

      log subscription

      user.subscriptions.create(
        :start_date       => Date.today,
        :payment_provider => 'stripe',
        :rate_cents       => subscription.plan.amount,
        :coupon_code      => coupon,
        :interval         => params[:interval]
      )

      user.update_attributes(
        :payment_provider    => 'stripe',
        :payment_provider_id => customer.id
      )

      user.enable
    end

    def change_interval(new_interval)
      new_plan = find_plan(new_interval)

      subscription = customer.update_subscription(
        :plan => new_plan, :prorate => true)

      user.subscriptions.active.update_attributes(:finish_date => Date.today)

      user.subscriptions.create(
        :start_date       => Date.today,
        :payment_provider => 'stripe',
        :rate_cents       => subscription.plan.amount,
        :interval         => new_interval
      )
    end

    def unsubscribe
      begin
        customer.cancel_subscription
      rescue ::Stripe::InvalidRequestError => e
        raise unless e.message[/No active subscription/]
      end

      user.disable
    end

    def charge_failed(charge)
      log charge

      AccountMailer.failed_payment(user, charge)
    end

    def subscription_ended(subscription)
      log subscription

      user.disable
    end

    def payment_created(invoice)
      raise "Invoice #{invoice.id} has not been paid" unless invoice.paid

      payment = user.payments.where(:stripe_invoice_id => invoice.id).
        first_or_create

      payment.update_attributes(
        :invoice_date          => Time.at(invoice.date).to_date,
        :amount                => invoice.total / 100.0,
        :credit_card_last_four => user.credit_card.try(:last_four)
      )

      AccountMailer.payment_created(user, payment) unless payment.email_sent?
    end

    def update_credit_card(params)
      token    = params[:stripeToken]
      customer = find_customer

      customer.card = token
      customer.save

      save_credit_card(customer.active_card)
    end

    def current_credit_card
      customer = find_customer

      customer.active_card
    end

    def customer
      @customer ||= find_customer
    end

    private

    attr_reader :user

    def find_or_create_customer(token)
      find_customer || create_customer(token)
    end

    def find_customer
      if user.payment_provider == 'stripe' && !user.payment_provider_id.blank?
        customer = ::Stripe::Customer.retrieve(user.payment_provider_id)
        customer unless customer["deleted"]
      end
    end

    def find_plan(interval)
      case interval
      when "month"
        "practicing-ruby-monthly"
      when "year"
        "practicing-ruby-yearly"
      end
    end

    def create_customer(token)
      customer = ::Stripe::Customer.create(
        :card        => token,
        :description => user.github_nickname,
        :email       => user.contact_email
      )

      log customer

      customer
    end

    def save_credit_card(stripe_card)
      card = CreditCard.find_or_create_by_user_id(@user.id)

      card.last_four        = stripe_card.last4
      card.expiration_month = stripe_card.exp_month
      card.expiration_year  = stripe_card.exp_year

      card.save
    end

    def log(object)
      PaymentLog.create(:user_id => user.id, :raw_data => object.to_json)
    end
  end
end
