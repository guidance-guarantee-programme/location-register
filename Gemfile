source 'https://rubygems.org'

ruby IO.read('.ruby-version').strip

gem 'rails', '~> 5.0.2'
gem 'pg', '~> 0.15'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2.0'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

gem 'foreman'
gem 'puma'

gem 'alphabetical_paginate'
gem 'bugsnag'
gem 'deprecated_columns'
gem 'faraday'
gem 'faraday_middleware'
gem 'gaffe'
gem 'gds-sso'
gem 'geocoder'
gem 'govuk_admin_template'
gem 'json', '~> 2.0.3'
gem 'newrelic_rpm'
gem 'plek'
gem 'pundit'
gem 'uk_postcode'
gem 'select2-rails'
gem 'sidekiq'

group :development, :test do
  gem 'dotenv-rails'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'scss-lint'
end

group :development do
  gem 'rubocop', '0.45.0', require: false
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'poltergeist'
  gem 'phantomjs', require: 'phantomjs/poltergeist'
  gem 'phantomjs-binaries'
  gem 'site_prism'
  gem 'vcr'
  gem 'webmock'
end

group :staging, :production do
  gem 'rails_12factor'
end
