set -x
set -e

export TERM=xterm
export PATH=/var/lib/jenkins/.rbenv/shims:/var/lib/jenkins/.rbenv/bin:/usr/local/bin:/usr/bin:/bin

vagrant destroy -f
bundle
bundle exec librarian-chef install
vagrant plugin install vagrant-omnibus

vagrant up || vagrant provision

wget -N http://bosh-jenkins-gems-warden.s3.amazonaws.com/stemcells/latest-bosh-stemcell-warden.tgz
sleep 30
bundle exec bosh -n target 192.168.100.4:25555
bundle exec bosh -u admin -p admin -n upload stemcell ./latest-bosh-stemcell-warden.tgz

#rm -rf ./cf-release
[ -d cf-release ] || git clone git@github.com:cloudfoundry/cf-release.git

(
  cd cf-release
  git checkout deployed-to-prod
  git reset --hard
  ./update
)

CF_RELEASE_DIR=`pwd`/cf-release ./scripts/make_manifest_spiff

(
  cd cf-release
  bundle install
  echo "---\ndev_name: cf" > ./config/dev.yml
  bundle exec bosh -n create release --force
  bundle exec bosh -u admin -p admin -n upload release
  bundle exec bosh -u admin -p admin -n deploy
)

scripts/add-route ||true
curl http://ccng.10.245.0.254.xip.io/info | grep vcap

vagrant destroy -f
