# create cf release
set -e
set -x
PATH=/opt/rbenv/shims:/opt/rbenv/bin:$PATH

ifconfig lo:1 192.168.50.4 netmask 255.255.255.0

cd /tmp/bosh-lite/
bundle install
rbenv rehash
bosh -n target 192.168.50.4

wget -r --tries=10 http://bosh-jenkins-gems-warden.s3.amazonaws.com/stemcells/latest-bosh-stemcell-warden.tgz -O /tmp/latest-bosh-stemcell-warden.tgz
bosh -u admin -p admin -n upload stemcell /tmp/latest-bosh-stemcell-warden.tgz

(
  cd cf-release
  git checkout deployed-to-prod
)

wget  -r --tries=10 https://github.com/vito/spiff/releases/download/v0.2/spiff_linux_amd64 -O /usr/local/bin/spiff
chmod +x /usr/local/bin/spiff
mkdir -p tmp
CF_RELEASE_DIR=cf-release ./scripts/make_manifest_spiff

(
  cd cf-release
  last=` tail -1 releases/index.yml |grep -Po "\d+"`
  bosh -u admin -p admin -n upload release releases/cf-${last}.yml
  bosh -u admin -p admin -n deploy
)
