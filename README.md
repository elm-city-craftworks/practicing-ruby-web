# Practicing Ruby

Sorry for how bad this README is, we will surely improve it in time. Right now
this app is publicly available primarily for the sake of transparency, but
there is very little code in here specific to practicingruby.com, so we
definitely want to generalize it eventually. Do feel free to email
**gregory@mendicantuniversity.org** with any questions you have about this app.

This project is licensed under the [GNU Affero General Public License 3.0](http://www.gnu.org/licenses/agpl-3.0.html).
Contributors retain copyright to their own code, but must agree to license any
code submitted to us under the same license as the project itself.


[![Build Status](https://secure.travis-ci.org/elm-city-craftworks/practicing-ruby-web.png?branch=master)](http://travis-ci.org/elm-city-craftworks/practicing-ruby-web)

1. install pygments easy_install Pygments
1. install postgres
1. install qtwebkit
1. bundle install
1. create config/database.yml
1. create config/initializers/mailchimp_settings.rb
1. create config/initializers/secret_token.rb
1. create config/initializers/omniauth.rb
  - you'll need to go to https://github.com/settings/applications/new and
    enter the following information to get your keys:
  ```
  application name: localhost  
  main url: http://localhost:3000  
  callback url: http://localhost:3000/auth/github/callback
  ```
1. create config/initializers/cache_cooker_settings.rb
1. create config/gollum_settings.rb
1. run rake db:create
1. run rake db:migrate
1. use rails console to create a new user `User.new`
1. start the server via `rails s`
1. navigate to `localhost:3000`
1. login via github
1. navigate to `localhost:3000/admin/articles` and create a new article
1. you can now navigate to `localhost:3000/library`
