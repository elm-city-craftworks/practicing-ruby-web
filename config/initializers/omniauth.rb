Rails.application.config.middleware.use OmniAuth::Builder do
  case ENV["AUTH_MODE"]
  when "developer"
    provider :developer, :fields => [:nickname], :uid_field => :nickname
  when "github"
    provider :github, ENV["GITHUB_CLIENT_KEY"], ENV["GITHUB_SECRET"] 
  end
end
