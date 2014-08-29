#!/bin/bash -l
set -x
set -e

export TERM=xterm
export PATH=/var/lib/jenkins/.rbenv/shims:/var/lib/jenkins/.rbenv/bin:/usr/local/bin:/usr/bin:/bin:$PATH
export RBENV_VERSION=1.9.3-p547

CUD=$(pwd)
export TMPDIR=$CUD

env

PRIVATE_NETWORK_IP=${PRIVATE_NETWORK_IP:-192.168.50.4}
sed -i'' -e "s/192.168.50.4/$PRIVATE_NETWORK_IP/" Vagrantfile
sed -i'' -e "s/192.168.50.4/$PRIVATE_NETWORK_IP/" bin/add-route

cleanup() {
  set +e

  cd $CUD
  vagrant destroy -f

  # Reset any changes made for this test
  git checkout Vagrantfile bin/add-route
}

trap cleanup EXIT

set +e
vagrant destroy -f
set -e

rm -rf /var/lib/jenkins/.bosh_cache/* || true

vagrant box add bosh-lite-${BOX_TYPE}-ubuntu-trusty-${CANDIDATE_BUILD_NUMBER}.box --name bosh-lite-ubuntu-trusty --force
vagrant up --provider=${PROVIDER}

./bin/add-route || true

if [ ! -d 'bosh' ]; then
  git clone --depth=1 https://github.com/cloudfoundry/bosh.git
fi

(
  set -e

  cd bosh
  git checkout master
  git pull
  git submodule update --init --recursive
  bundle install

  bundle exec bosh -n target $PRIVATE_NETWORK_IP
  wget -nv -N https://s3.amazonaws.com/bosh-jenkins-artifacts/bosh-stemcell/warden/latest-bosh-stemcell-warden.tgz
  bundle exec bosh -u admin -p admin -n upload stemcell ./latest-bosh-stemcell-warden.tgz

  cat > bat.spec << EOF
---
cpi: warden
properties:
  static_ip: 10.244.0.2
  uuid: $(bundle exec bosh -u admin -p admin status --uuid | tail -n 1)
  pool_size: 1
  stemcell:
    name: bosh-warden-boshlite-ubuntu-trusty-go_agent
    version: latest
  instances: 1
  mbus: nats://nats:nats-password@10.254.50.4:4222
EOF
  cat bat.spec

  export BAT_DEPLOYMENT_SPEC=`pwd`/bat.spec
  export BAT_DIRECTOR=$PRIVATE_NETWORK_IP
  export BAT_DNS_HOST=$PRIVATE_NETWORK_IP
  export BAT_STEMCELL=`pwd`/latest-bosh-stemcell-warden.tgz
  export BAT_VCAP_PASSWORD=c1oudc0w
  export BAT_INFRASTRUCTURE=warden

  cd bat
  bundle exec rake bat || bundle exec rake bat # remove after monit issue is fixed
)

s3cmd put -P bosh-lite-${BOX_TYPE}-ubuntu-trusty-${CANDIDATE_BUILD_NUMBER}.box s3://bosh-lite-build-artifacts/
