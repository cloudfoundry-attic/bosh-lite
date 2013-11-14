%w(
 libmysqlclient-dev
 libsqlite3-dev
).each do |package_name|
  package package_name
end


git "/tmp/bosh-lite" do
  repository "git://github.com/cloudfoundry/bosh-lite.git"
  action :sync
end

git "/tmp/bosh-lite/cf-release" do
  repository "git://github.com/cloudfoundry/cf-release.git"
  action :sync
end
