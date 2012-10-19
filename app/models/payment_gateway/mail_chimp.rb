module PaymentGateway
  class MailChimp

    def initialize(user)
      @user = user
    end

    def subscribe(params = {})
      raise NotImplementedError
    end
  end
end