execute 'apt-get make' do
  command 'apt-get install make'
  ignore_failure true
  action :nothing
end.run_action(:run)

execute 'apt-get-update' do
  command 'apt-get update'
  ignore_failure true
  action :nothing
end.run_action(:run)

