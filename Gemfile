source 'https://rubygems.org'
ruby '2.2.1'

gem 'rails', '4.2.3'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'slim-rails'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'excon'
gem 'github_api'
gem 'foundation-rails'

# Heroku
gem 'rails_12factor'
gem 'heroku_secrets', github: 'alexpeattie/heroku_secrets'

# Application server
gem 'passenger'

# Errors and Exceptions
gem 'rollbar'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails'
  gem 'mailcatcher'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'rr', require: false
end
