module PaymentGateway
  class Stripe

    def initialize(user)
      @user            = user
      ::Stripe.api_key = STRIPE_SECRET_KEY
    end

    def subscribe(params = {})
      token = params[:stripeToken]

      customer = find_or_create_customer(token)

      # TODO Log Response
      subscription = customer.update_subscription(
        :plan => "practicing-ruby-monthly"
      )

      user.subscriptions.create(
        :start_date       => Date.today,
        :payment_provider => 'stripe',
        :monthly_rate     => subscription.plan.amount / 100.0 # Convert to dollars
      )

      user.update_attributes(
        :payment_provider    => 'stripe',
        :payment_provider_id => customer.id
      )

      user.enable
    end

    def unsubscribe
      customer = find_customer

      begin
        customer.cancel_subscription
      rescue ::Stripe::InvalidRequestError => e
        raise unless e.message[/No active subscription/]
      end

      if user.subscriptions.active
        user.subscriptions.active.update_attributes(:finish_date => Date.today)
      end

      user.disable
    end

    private

    attr_reader :user

    def find_or_create_customer(token)
      find_customer || create_customer(token)
    end

    def find_customer
      if user.payment_provider == 'stripe' && !user.payment_provider_id.blank?
        begin
          customer = ::Stripe::Customer.retrieve(user.payment_provider_id)
          if customer["deleted"]
            nil
          else
            customer
          end
        rescue ::Stripe::InvalidRequestError => e
          # Don't raise an exception if the customer doesn't exist in Stripe
          raise unless e.message[/No such customer/]
        end
      end
    end

    def create_customer(token)
      # TODO Log Response
      ::Stripe::Customer.create(
        :card        => token,
        :description => user.github_nickname,
        :email       => user.contact_email
      )
    end
  end
end