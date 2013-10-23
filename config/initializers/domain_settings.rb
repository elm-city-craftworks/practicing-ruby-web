url_options = { :host => ENV["HOST"] }

ActionMailer::Base.default_url_options       = url_options
Rails.application.routes.default_url_options = url_options
