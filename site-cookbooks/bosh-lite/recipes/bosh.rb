%w(
  libssl-dev
  libreadline-dev
  build-essential
  zlib1g-dev
  git
  libxml2-dev
  libxslt-dev
  libsqlite3-dev
  libyaml-dev
  libyajl-dev
  curl
  genisoimage
  kpartx
  debootstrap
  wamerican
  redis-server
  nginx
  libcurl4-openssl-dev
).each do |package_name|
  package package_name
end

include_recipe 'rbenv::default'
include_recipe 'rbenv::ruby_build'
include_recipe 'runit'

rbenv_ruby '1.9.3-p392' do
  global true
end

%w(sqlite3 nats).each do |gem|
  rbenv_gem gem
end

%w(bosh_registry director simple_blobstore_server health_monitor).each do |gem|
  rbenv_gem gem do
    version '1.5.0.pre.721'
    source 'https://s3.amazonaws.com/bosh-jenkins-gems/'
  end
end

rbenv_gem 'bosh_docker_cpi' do
  version '>=0.0.0'
  options('--prerelease')
end

%w(config blobstore director db).each do |dir|
  directory "/opt/bosh/#{dir}" do
    owner 'vagrant'
    mode 0755
    action :create
    recursive true
  end
end

%w(bosh_registry.yml director.yml health_monitor.yml simple_blobstore_server.yml).each do |config_file|
  cookbook_file "/opt/bosh/config/#{config_file}" do
    owner 'vagrant'
  end
end

cookbook_file '/etc/nginx/nginx.conf' do
  mode 0755
end

execute 'migrate' do
  user 'vagrant'
  command '/opt/rbenv/shims/migrate -c /opt/bosh/config/director.yml'
end

directory '/etc/nginx/ssl' do
  mode 0755
  action :create
end

execute 'create director ssl key and csr' do
  command 'openssl req -nodes -new -newkey rsa:1024 -out /etc/nginx/ssl/director.csr -keyout /etc/nginx/ssl/director.key -subj \'/O=Bosh/CN=*\''
end

execute 'self sign director ssl csr' do
  command 'openssl x509 -req -days 3650 -in /etc/nginx/ssl/director.csr -signkey /etc/nginx/ssl/director.key -out /etc/nginx/ssl/director.pem'
end

%w(nats blobstore registry director worker health_monitor).each do |service_name|
  runit_service service_name do
    default_logger true
    options({:user => 'vagrant'})
  end
end
