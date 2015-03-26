#!/usr/bin/env bash

set -e -x

run_bats() {
  director_ip=$1
  stemcell_os_name=$2

  config_file=bosh-$RANDOM.yml

  if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    # bosh_cli expects this key to exist
    ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
  fi

  git clone --depth=1 https://github.com/cloudfoundry/bosh.git

  cd bosh

  rm -rf ./.bundle
  bundle install

  # the director may not be running yet, so allow one failure
  sleep 10

  bundle exec bosh -c $config_file -n target $director_ip

  if [ -z "$BAT_STEMCELL" ]; then
    wget -nv -N https://s3.amazonaws.com/bosh-jenkins-artifacts/bosh-stemcell/warden/latest-bosh-stemcell-warden.tgz
    export BAT_STEMCELL=`pwd`/latest-bosh-stemcell-warden.tgz
  fi

  bundle exec bosh -c $config_file -u admin -p admin -n upload stemcell $BAT_STEMCELL

  cat > bat.spec << EOF
---
cpi: warden
properties:
  static_ip: 10.244.0.2
  uuid: $(bundle exec bosh -c $config_file -u admin -p admin status --uuid | tail -n 1)
  pool_size: 1
  persistent_disk: 100
  stemcell:
    name: bosh-warden-boshlite-$stemcell_os_name-go_agent
    version: latest
  instances: 1
  mbus: nats://nats:nats-password@10.254.50.4:4222
  networks:
  - type: manual
    static_ip: 10.244.0.2
EOF

  export BAT_DEPLOYMENT_SPEC=`pwd`/bat.spec
  export BAT_DIRECTOR=$director_ip
  export BAT_DNS_HOST=$director_ip
  export BAT_VCAP_PASSWORD=c1oudc0w
  export BAT_INFRASTRUCTURE=warden
  export BAT_NETWORKING=manual

  cd bat
  bundle exec rake bat

  rm -f $config_file
}

install_bats_prereqs() {
  sudo apt-get -y update
  sudo apt-get install -y git libmysqlclient-dev libpq-dev libsqlite3-dev
  sudo gem install bundler --no-ri --no-rdoc
}

run_bats_on_vm() {
  stemcell_os_name=$1

  vagrant ssh -c "set -e -x; $(declare -f install_bats_prereqs); install_bats_prereqs"
  vagrant ssh -c "set -e -x; $(declare -f run_bats); run_bats 127.0.0.1 $stemcell_os_name"
}
