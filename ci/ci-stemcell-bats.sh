#!/usr/bin/env bash
set -ex

export TERM=xterm
export PATH=/var/lib/jenkins/.rbenv/shims:/var/lib/jenkins/.rbenv/bin:/usr/local/bin:/usr/bin:/bin

env

rm -rf /var/lib/jenkins/.bosh_cache/*

cleanup() {
  set +e
  cd bosh-lite
  vagrant destroy -f
}

trap cleanup EXIT

vagrant up --provider=virtualbox

rm -rf output

(
  set -ex

  if [ ! -d 'bosh' ]; then
    git clone --depth=1 https://github.com/cloudfoundry/bosh.git
  fi

  cd bosh
  git checkout master
  git pull
  git submodule update --init --recursive
  bundle install

  bundle exec bosh -c stemcell-bat-test-ubuntu-trusty.yml -n target 192.168.50.4
  bundle exec bosh -c stemcell-bat-test-ubuntu-trusty.yml -u admin -p admin -n upload stemcell ../bosh-stemcell-$CANDIDATE_BUILD_NUMBER-warden-boshlite-ubuntu-trusty-go_agent.tgz

  cat > bat.spec << EOF
---
cpi: warden
properties:
  static_ip: 10.244.0.2
  uuid: $(bundle exec bosh -c stemcell-bat-test-ubuntu-trusty.yml -u admin -p admin status --uuid | tail -n 1)
  pool_size: 1
  stemcell:
    name: bosh-warden-boshlite-ubuntu-trusty-go_agent
    version: latest
  instances: 1
  mbus: nats://nats:0b450ada9f830085e2cdeff6@10.42.49.80:4222
EOF
  cat bat.spec

  export BAT_DEPLOYMENT_SPEC=$(pwd)/bat.spec
  export BAT_DIRECTOR=192.168.50.4
  export BAT_DNS_HOST=192.168.50.4
  export BAT_STEMCELL=$(pwd)/../bosh-stemcell-$CANDIDATE_BUILD_NUMBER-warden-boshlite-ubuntu-trusty-go_agent.tgz
  export BAT_VCAP_PASSWORD=c1oudc0w
  export BAT_INFRASTRUCTURE=warden

  cd bat
  bundle exec rake bat
)

mkdir -p output
mv bosh-stemcell-$CANDIDATE_BUILD_NUMBER-warden-boshlite-ubuntu-trusty-go_agent.tgz output/
