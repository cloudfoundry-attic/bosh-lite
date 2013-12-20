set -x
set -e

export TERM=xterm
export PATH=/var/lib/jenkins/.rbenv/shims:/var/lib/jenkins/.rbenv/bin:/usr/local/bin:/usr/bin:/bin
CUD=$(pwd)

export TMPDIR=$CUD

cleanup()
{
  cd $CUD/bosh-lite
  vagrant destroy -f
}
trap cleanup EXIT


rm -rf bosh-lite || true

git checkout deployed-to-prod
last=` tail -1 releases/index.yml |grep -Po "\d+"`
ref=${CF_VERSION:-"$last"}
git checkout v${ref}


bundle install

echo $CANDIDATE_BUILD_NUMBER

git clone https://github.com/cloudfoundry/bosh-lite.git

(
  cd bosh-lite
  bundle install
  vagrant destroy -f || true
  rm -rf /var/lib/jenkins/.bosh_cache/* || true
  vagrant box remove boshlite-cf-ubuntu1204 virtualbox || true
  vagrant up
  sleep 30

  bundle exec bosh -n target 192.168.50.4:25555

  bosh -u admin -p admin -n upload stemcell ../bosh-stemcell-$CANDIDATE_BUILD_NUMBER-warden-boshlite-ubuntu.tgz
  CF_RELEASE_DIR=../ ./scripts/make_manifest_spiff
)

cmd="bosh -u admin -p admin -n upload release releases/cf-${ref}.yml"
$cmd || (sleep 120; bosh -u admin -p admin releases | grep cf ) || $cmd

# new stemcell name changed
# TODO update template in cf-release
sed -i s/bosh-stemcell/bosh-warden-boshlite-ubuntu/ $CUD/bosh-lite/manifests/cf-manifest.yml

bosh -u admin -p admin -n deploy

rm -rf nyet || true
git clone https://github.com/cloudfoundry/nyet.git

(
  cd nyet
  bundle install
  export NYET_TARGET="http://api.10.244.0.34.xip.io"
  export NYET_ADMIN_USERNAME="admin"
  export NYET_ADMIN_PASSWORD="admin"
  export NYET_REGULAR_USERNAME="admin"
  export NYET_REGULAR_PASSWORD="admin"
  bundle exec rake spec
)

s3cmd put -P ./bosh-stemcell-$CANDIDATE_BUILD_NUMBER-warden-boshlite-ubuntu.tgz s3://bosh-jenkins-gems-warden/stemcells/ubuntu/
s3cmd put -P ./bosh-stemcell-$CANDIDATE_BUILD_NUMBER-warden-boshlite-ubuntu.tgz s3://bosh-jenkins-gems-warden/stemcells/ubuntu/latest-bosh-stemcell-warden-ubuntu.tgz

