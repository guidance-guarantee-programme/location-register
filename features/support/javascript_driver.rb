if ENV['WITHOUT_JS']
  Capybara.javascript_driver = :rack_test
else
  require 'capybara/poltergeist'

  Capybara.javascript_driver = :poltergeist
  Capybara.default_max_wait_time = 20
end
