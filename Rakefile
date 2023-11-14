# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:default)

  namespace :cucumber do
    desc 'Run cucumber features tagged with @javascript rack_test driver'
    task :javascript_disabled do
      puts '*' * 50
      puts 'Running cucumber features with JS disabled...'
      puts '*' * 50
      system('WITHOUT_JS=true cucumber --tags @noscript')
    end
  end

  task default: 'cucumber:javascript_disabled'
rescue LoadError
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:default)
rescue LoadError
end

begin
  require 'scss_lint/rake_task'
  SCSSLint::RakeTask.new(:default)
rescue LoadError
end

task default: %i[analyse_javascript]
