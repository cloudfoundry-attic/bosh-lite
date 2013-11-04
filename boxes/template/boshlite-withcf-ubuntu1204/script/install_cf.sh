# create cf release
set -e
set -x
PATH=/opt/rbenv/shims:/opt/rbenv/bin:$PATH

ifconfig lo:1 192.168.50.4 netmask 255.255.255.0

cd /tmp/bosh-lite/
bundle install
rbenv rehash
bosh -n target 127.0.0.1:25555

wget -r --tries=10 http://bosh-jenkins-gems-warden.s3.amazonaws.com/stemcells/latest-bosh-stemcell-warden.tgz -O /tmp/latest-bosh-stemcell-warden.tgz
bosh -u admin -p admin -n upload stemcell /tmp/latest-bosh-stemcell-warden.tgz

(
  cd cf-release
  git checkout release-candidate
  git reset --hard
  ./update
)

cp manifests/cf-stub.yml manifests/cf-manifest.yml
DIRECTOR_UUID=$(bundle exec bosh status | grep UUID | awk '{print $2}')
echo $DIRECTOR_UUID
perl -pi -e "s/PLACEHOLDER-DIRECTOR-UUID/$DIRECTOR_UUID/g" manifests/cf-manifest.yml
bosh -n deployment manifests/cf-manifest.yml
bosh -n diff ./cf-release/templates/cf-aws-template.yml.erb
scripts/transform.rb -f manifests/cf-manifest.yml

(
  cd cf-release
  bundle install
  cp -f /tmp/dev.yml ./config/
  bosh -n create release --force
  bosh -u admin -p admin -n upload release
  bosh -u admin -p admin -n deploy
)

