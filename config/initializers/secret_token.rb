token = Rails.env.production? ? ENV["SECRET_TOKEN"] : ('x' * 30)

PracticingRubyWeb::Application.config.secret_token = token
