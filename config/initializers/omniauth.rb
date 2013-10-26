Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV["GITHUB_CLIENT_KEY"], ENV["GITHUB_SECRET"] 

  if Rails.env.development?
    provider :developer, :fields => [:nickname], :uid_field => :nickname
  end
end
