source 'https://rubygems.org'

ruby IO.read('.ruby-version').strip

gem 'pg'
gem 'rails', '~> 6.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'jbuilder'
gem 'jquery-rails'

gem 'foreman'
gem 'puma'

gem 'alphabetical_paginate', github: 'benlovell/alphabetical_paginate'
gem 'azure-storage-blob', '~> 2'
gem 'bugsnag'
gem 'deprecated_columns'
gem 'faraday'
gem 'faraday_middleware'
gem 'gaffe'
gem 'gds-sso'
gem 'geocoder'
gem 'govuk_admin_template'
gem 'oj'
gem 'plek', '~> 2.1'
gem 'postgres-copy'
gem 'pundit'
gem 'select2-rails'
gem 'sidekiq', '< 7'
gem 'sinatra', require: false
gem 'uk_postcode'

group :development, :test do
  gem 'dotenv-rails'
  gem 'launchy'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'scss-lint'
end

group :development do
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'phantomjs'
  gem 'poltergeist'
  gem 'site_prism'
  gem 'vcr'
  gem 'webmock'
end

group :staging, :production do
  gem 'rails_12factor'
end
