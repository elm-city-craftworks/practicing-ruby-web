case ENV["SMTP_PROVIDER"]
when "sendgrid"
  ActionMailer::Base.smtp_settings = {
    :address              => "smtp.sendgrid.net",
    :port                 => 587,
    :domain               => ENV["SMTP_DOMAIN"],
    :user_name            => ENV["SMTP_USERNAME"],
    :password             => ENV["SMTP_PASSWORD"],
    :authentication       => "plain",
    :enable_starttls_auto => true
  }
when "mailcatcher"
  ActionMailer::Base.smtp_settings = { 
    :address => "localhost", 
    :port => 1025 
  }
else
  warn "ActionMailer::Base.smtp_settings was not set!"
end
