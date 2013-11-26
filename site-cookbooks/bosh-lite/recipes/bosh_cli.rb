include_recipe 'bosh-lite::rbenv'

rbenv_gem 'bosh_cli' do
  ruby_version "1.9.3-p448"
  version '~>1.5.0.pre.847'
end

rbenv_gem 'bosh_cli' do
  ruby_version "1.9.3-p484"
  version '~>1.5.0.pre.847'
end
