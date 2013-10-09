# create cf release
PATH=/opt/rbenv/shims/:$PATH

cd /tmp/bosh-lite/
bundle
bundle exec bosh -n target 127.0.0.1:25555

wget -r --tries=10 http://bosh-jenkins-gems-warden.s3.amazonaws.com/stemcells/latest-bosh-stemcell-warden.tgz -O ./latest-bosh-stemcell-warden.tgz
bundle exec bosh -u admin -p admin -n upload stemcell ./latest-bosh-stemcell-warden.tgz

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
bundle exec bosh -n deployment manifests/cf-manifest.yml
bundle exec bosh -n diff ./cf-release/templates/cf-aws-template.yml.erb
scripts/transform.rb -f manifests/cf-manifest.yml

(
  cd cf-release
  bundle
  echo "---\ndev_name: cf-release" > ./config/dev.yml
  bundle exec bosh -n create release --force
  bundle exec bosh -u admin -p admin -n upload release
  bundle exec bosh -u admin -p admin -n deploy
)

