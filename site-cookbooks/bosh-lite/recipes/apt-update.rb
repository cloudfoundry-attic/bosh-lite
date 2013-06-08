execute 'apt-get-update' do
  command 'apt-get update'
  ignore_failure true
  action :nothing
end
