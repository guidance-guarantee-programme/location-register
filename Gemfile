source 'https://rubygems.org'

ruby IO.read('.ruby-version').strip

gem 'rails', '4.2.7.1'
gem 'pg', '~> 0.15'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'foreman'
gem 'puma'

gem 'alphabetical_paginate'
gem 'bugsnag'
gem 'deprecated_columns'
gem 'gaffe'
gem 'gds-sso'
gem 'geocoder'
gem 'govuk_admin_template'
gem 'newrelic_rpm'
gem 'plek'
gem 'pundit'
gem 'uk_postcode'

group :development, :test do
  gem 'dotenv-rails'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'scss-lint'
end

group :development do
  gem 'rubocop', require: false
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'poltergeist'
  gem 'phantomjs', require: 'phantomjs/poltergeist'
  gem 'site_prism'
  gem 'vcr'
  gem 'webmock'
end

group :staging, :production do
  gem 'rails_12factor'
end
