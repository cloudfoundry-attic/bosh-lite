set -x
set -e

export TERM=xterm
export PATH=/var/lib/jenkins/.rbenv/shims:/var/lib/jenkins/.rbenv/bin:/usr/local/bin:/usr/bin:/bin

CUD=$(pwd)

cleanup()
{
  cd $CUD/bosh-lite
  vagrant destroy -f
}

trap cleanup EXIT

rm $CUD/output/*.tgz || true

rm -rf bosh-lite || true
git clone https://github.com/cloudfoundry/bosh-lite.git

echo $CANDIDATE_BUILD_NUMBER

rm -rf /var/lib/jenkins/.bosh_cache/* || true

(
  cd bosh-lite
  vagrant box remove boshlite-ubuntu1204 virtualbox || true
  vagrant up
)


sleep 30

bundle exec bosh -n target 192.168.100.4:25555

# a pre upload so we stopped early when director dies etc.
bundle exec bosh -u admin -p admin -n upload stemcell ./bosh-stemcell-$CANDIDATE_BUILD_NUMBER-warden-boshlite-ubuntu.tgz || sleep 30

DIRECTOR_UUID=$(bosh -u admin -p admin status | grep UUID | awk '{print $2}')
echo $DIRECTOR_UUID

# Create bat.spec
cat > bat.spec << EOF
---
cpi: warden
properties:
  static_ip: 10.245.0.2
  uuid: $DIRECTOR_UUID
  pool_size: 1
  stemcell:
    name: bosh-warden-boshlite-ubuntu
    version: latest
  instances: 1
  mbus: nats://nats:0b450ada9f830085e2cdeff6@10.42.49.80:4222
EOF


export BAT_DEPLOYMENT_SPEC=$CUD/bat.spec
export BAT_DIRECTOR=192.168.100.4
export BAT_DNS_HOST=192.168.100.4
export BAT_STEMCELL=$CUD/bosh-stemcell-$CANDIDATE_BUILD_NUMBER-warden-boshlite-ubuntu.tgz
export BAT_VCAP_PASSWORD=c1oudc0w

(
  cd bat
  bundle exec rake bat
)

cd $CUD
mkdir output || true
mv $CUD/bosh-stemcell-$CANDIDATE_BUILD_NUMBER-warden-boshlite-ubuntu.tgz $CUD/output/
