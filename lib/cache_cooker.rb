class CacheCooker
  include HTTParty

  # HTTP Digest Realm
  #
  def self.realm(realm = nil)
    if realm
      default_options[:realm] = realm
    else
      default_options[:realm]
    end
  end

  # Set these values in `/config/initializers/cache_cooker_settings.rb`
  #
  # digest_auth 'cachecooker', 'secret'
  # base_uri    'http://practicingruby.dev'
  # realm       'Practicing Ruby'

  # 'Bake' a given url, creating cache files if necessary
  #
  def self.bake(url)
    CacheCooker.get(url, :headers => {'cache-cooker' => 'enabled'})
  end

  # Include +Oven+ in your ApplicationController and call
  # +authenticate_cache_cooker+ in a before filter to check for cache cooker
  # requests.
  #
  # class ApplicationController < ActionController::Base
  #   include CacheCooker::Oven
  #   before_filter :authenticate
  #
  #   private
  #
  #   def authenticate
  #     if authenticate_cache_cooker
  #       current_user = SomeUser
  #     end
  #   end
  # end
  #
  module Oven
    private

    def authenticate_cache_cooker
      return false unless request.env["HTTP_CACHE_COOKER"]

      authenticate_or_request_with_http_digest(CacheCooker.realm) do |user|
        unless user == CacheCooker.default_options[:digest_auth][:username]
          return false
        end

        password = CacheCooker.default_options[:digest_auth][:password]

        Digest::MD5.hexdigest([user, CacheCooker.realm, password].join(":"))
      end
    end
  end
end