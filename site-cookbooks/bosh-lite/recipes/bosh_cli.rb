include_recipe 'bosh-lite::rbenv'

rbenv_gem 'bosh_cli' do
  version '~>1.5.0.pre.847'
end
