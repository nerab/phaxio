#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rubocop/rake_task'

require 'rake/testtask'
RuboCop::RakeTask.new

namespace :test do
  desc 'All tests'
  task all: [:unit, :integration]

  desc 'Unit tests'
  Rake::TestTask.new(:unit) do |t|
    t.libs << 'test'
    t.test_files = FileList['test/unit/test*.rb']
  end

  desc 'Integration tests'
  Rake::TestTask.new(:integration) do |t|
    t.libs << 'test'
    t.test_files = FileList['test/integration/test*.rb']
  end
end

desc 'Run all tests'
task default: :'test:all'
