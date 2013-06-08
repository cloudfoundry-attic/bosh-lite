require 'rspec'
require 'rspec/core/rake_task'
require 'bundler/gem_helper'
Bundler::GemHelper.install_tasks(:dir => File.expand_path('bosh_docker_cpi'))

RSpec::Core::RakeTask.new(:spec)

task :default => [:spec]
