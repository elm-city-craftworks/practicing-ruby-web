![Practicing Ruby](https://raw.github.com/elm-city-craftworks/practicing-ruby-web/master/doc/header.png)

[![Build Status](https://secure.travis-ci.org/elm-city-craftworks/practicing-ruby-web.png?branch=master)](http://travis-ci.org/elm-city-craftworks/practicing-ruby-web)

This app is publicly available primarily for the sake of transparency, but
there is very little code in here specific to [practicingruby.com][pr], so we
definitely want to generalize it eventually. Do feel free to email
**gregory@practicingruby.com** with any questions you have about this app.

To find out more about Practicing Ruby visit [practicingruby.com][pr].

## Installation

Practicing Ruby is a Ruby on Rails 3.2 application which runs on Ruby 1.9.2+ 
and [PostgreSQL](http://www.postgresql.org) databases. Other databases like
MySQL or SQLite are not officially supported.

### Setting Up a Development Copy: Step by Step

To install a development version of Practicing Ruby, follow these steps:

1. Fork our GitHub repository: <http://github.com/elm-city-craftworks/practicing-ruby-web>
2. Clone the fork to your computer
3. If you don't already have bundler installed, get it by running `gem install bundler`
4. Run `bundle install` to install all of the project's dependencies
5. Finally, run `rake setup` to create the required config files, create the database, and seed it with data

To make things even easier, you can copy and paste this into your terminal once you've got the project cloned to your computer

```bash
gem install bundler
bundle install
bundle exec rake setup
```

## Contributing

Features and bugs are tracked through [Github Issues][issue-tracker].

Contributors retain copyright to their work but must agree to release their
contributions under the [Affero GPL version 3][gpl].

If you would like to help with developing Practicing Ruby, just file a ticket
in our [issue tracker][issue-tracker] and we will find something to keep you
busy.

### Submitting a Pull Request

1. If a ticket doesn't exist for your bug or feature, **get in touch with us 
   FIRST**
    - Create a ticket describing your idea or fix
    - Don't start working on your patch until you've heard back from a
      maintainer
    - We are being very picky about what features we're going to support, and 
      it breaks our hearts when we need to turn away perfectly good patches. 
      So please reach out to us first
2. Fork the project
3. Create a topic branch
4. Implement your feature or bug fix
5. Add documentation for your feature or bug fix
6. Add tests for your feature or bug fix
7. Run `rake test` If your changes are not 100% covered, go back to step 6
8. If your change affects something in this README, please update it
9. Commit and push your changes
10. Submit a pull request

### Contributors

Jordan Byron // [jordanbyron.com](http://jordanbyron.com) <br/>
Gregory Brown // [majesticseacreature.com](http://majesticseacreature.com/)

[Full List][contributors]

## License

Practicing Ruby is released under the [Affero GPL version 3][gpl].

If you wish to contribute to Practicing Ruby, you will retain your own
copyright but must agree to license your code under the same terms as the 
project itself.

------

Practicing Ruby - an [Elm City Craftworks](http://elmcitycraftworks.org) project

[pr]: https://practicingruby.com
[gpl]: http://www.gnu.org/licenses/agpl.html
[contributors]: https://github.com/elm-city-craftworks/practicing-ruby-web/contributors
[issue-tracker]: https://github.com/elm-city-craftworks/practicing-ruby-web/issues