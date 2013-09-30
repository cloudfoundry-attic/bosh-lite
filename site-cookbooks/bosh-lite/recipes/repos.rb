git "/tmp/bosh-lite" do
  repository "git://github.com/cloudfoundry/bosh-lite.git"
  action :sync
end

git "/tmp/bosh-lite/cf-release" do
  repository "git://github.com/cloudfoundry/cf-release.git"
  action :sync
end
