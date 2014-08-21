# Use source blobs from cf-release to construct nginx since it
# appears that there have been some modifications (to the upload
# module in particular) that are not present in the official
# repositories.
#
# These versions and hashes match what are used by bosh.

cache_path = Chef::Config[:file_cache_path]
nginx_tarball = 'nginx-1.4.5.tar.gz'
headers_more_tarball = 'headers-more-v0.25.tgz'
upload_module_tarball = 'nginx-upload-module-2.2.tar.gz'
pcre_tarball = 'pcre-8.34.tar.gz'

remote_file nginx_tarball do
  source 'https://blob.cfblob.com/8001e14c-1629-4305-bd5a-02e6ec9faa04'
  path File.join(cache_path, nginx_tarball)
  owner 'root'
  group node['root_group']
  mode '0644'
end

remote_file headers_more_tarball do
  source 'https://blob.cfblob.com/a621718d-df24-4205-ba31-6ed8a212732e'
  path File.join(cache_path, headers_more_tarball)
  owner 'root'
  group node['root_group']
  mode '0644'
end

remote_file upload_module_tarball do
  source 'https://blob.cfblob.com/502854f1-9823-468f-baef-1a8d68823ead'
  path File.join(cache_path, upload_module_tarball)
  owner 'root'
  group node['root_group']
  mode '0644'
end

remote_file pcre_tarball do
  source 'https://blob.cfblob.com/ee5bee99-dda0-4d81-be88-a7a1a901dae7'
  path File.join(cache_path, pcre_tarball)
  owner 'root'
  group node['root_group']
  mode '0644'
end

bash "build nginx" do
  cwd cache_path
  code <<-EOF
    set -e

    tar zxvf #{nginx_tarball}
    tar zxvf #{headers_more_tarball}
    tar zxvf #{upload_module_tarball}
    tar zxvf #{pcre_tarball}

    pushd nginx-1.4.5
      ./configure \
        --prefix=/etc/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --sbin-path=/usr/sbin/nginx \
        --with-pcre=../pcre-8.34 \
        --with-http_ssl_module \
        --with-http_dav_module \
        --add-module=../headers-more-nginx-module-0.25 \
        --add-module=../nginx-upload-module-2.2

      make
      make install
    popd
  EOF
  not_if { ::File.exists?('/usr/sbin/nginx') }
end

node.set['nginx']['dir'] = '/etc/nginx'
node.set['nginx']['binary'] = '/usr/sbin/nginx'
node.set['nginx']['pid'] = '/var/run/nginx.pid'
node.set['nginx']['user'] = 'vagrant'

include_recipe 'nginx::commons_dir'

template '/etc/init.d/nginx' do
  source 'nginx.init.erb'
  cookbook 'nginx'
  variables :src_binary => node['nginx']['binary'], :pid => node['nginx']['pid']
  owner 'root'
  group node['root_group']
  mode '0755'
end

%w(nginx.conf read_users write_users).each do |file|
  cookbook_file "/etc/nginx/#{file}" do
    mode 0755
  end
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

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action   [ :enable, :restart ]
end
