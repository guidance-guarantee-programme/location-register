# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new
rescue LoadError
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
rescue LoadError
end

begin
  require 'scss_lint/rake_task'
  SCSSLint::RakeTask.new
rescue LoadError
end

task default: %i(spec cucumber rubocop)
