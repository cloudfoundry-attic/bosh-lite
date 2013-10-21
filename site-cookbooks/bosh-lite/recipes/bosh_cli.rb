include_recipe 'bosh-lite::rbenv'

%w(
  vim
  ack-grep
  maven2
  default-jdk
).each do |package_name|
  package package_name
end

rbenv_gem 'bosh_cli' do
  version '~>1.5.0.pre.847'
end

rbenv_gem 'cf'
