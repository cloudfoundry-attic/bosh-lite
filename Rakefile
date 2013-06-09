require 'rspec'
require 'rspec/core/rake_task'
require 'bundler/gem_helper'
Bundler::GemHelper.install_tasks(:dir => File.expand_path('bosh_docker_cpi'))

RSpec::Core::RakeTask.new(:gem_spec)do |t|
  t.pattern = 'bosh_docker_cpi/spec{,/*/**}/*_spec.rb'
  t.rspec_opts = %w(--format documentation --color -Ibosh_docker_cpi/spec)
end

task :default => [:gem_spec]
