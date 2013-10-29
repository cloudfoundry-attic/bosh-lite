set -x
set -e
PATH=/home/jenkins/.rbenv/shims:/home/jenkins/.rbenv/bin:/home/jenkins/.rbenv/bin:$PATH

vagrant destroy -f
bundle
bundle exec librarian-chef install
vagrant plugin install vagrant-omnibus

vagrant up

wget -N http://bosh-jenkins-gems-warden.s3.amazonaws.com/stemcells/latest-bosh-stemcell-warden.tgz
sleep 60
bundle exec bosh -n target 192.168.50.4:25555
bundle exec bosh -u admin -p admin -n upload stemcell ./latest-bosh-stemcell-warden.tgz

rm -rf ./cf-release
git clone git@github.com:cloudfoundry/cf-release.git

(
  cd cf-release
  git checkout deployed-to-prod
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
echo "---\ndev_name: cf" > ./config/dev.yml
  bundle exec bosh -n create release --force
  bundle exec bosh -u admin -p admin -n upload release
  bundle exec bosh -u admin -p admin -n deploy
)

scripts/add-route ||true
curl http://ccng.10.244.0.254.xip.io/info | grep vcap

vagrant destroy -f
