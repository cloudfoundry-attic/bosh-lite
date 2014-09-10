#!/usr/bin/env bash
set -ex

export TERM=xterm
export PATH=/var/lib/jenkins/.rbenv/shims:/var/lib/jenkins/.rbenv/bin:/usr/local/bin:/usr/bin:/bin:$PATH
export RBENV_VERSION=1.9.3-p547

CUD=$(pwd)
export TMPDIR=$CUD

env

cleanup() {
  set +e

  cd $CUD
  vagrant destroy -f

  # Reset any changes made for this test
  git checkout .
}

clean_vagrant() {
  set +e
  vagrant destroy -f
  set -e

  rm -rf /var/lib/jenkins/.bosh_cache/* || true
}

box_add_and_vagrant_up() {
  set -e

  box_type=$1
  provider=$2
  candidate_build_number=$3

  vagrant box add bosh-lite-$box_type-ubuntu-trusty-$candidate_build_number.box --name bosh-lite-ubuntu-trusty-$box_type-$candidate_build_number --provider=$provider --force
  vagrant up --provider=$provider
}

run_bats() {
  set -e

  director_ip=$1
  config_file=bosh-$RANDOM.yml

  if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    # bosh_cli expects this key to exist
    ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
  fi

  set +e
  dpkg-query -l git libmysqlclient-dev libpq-dev libsqlite3-dev > /dev/null 2>&1
  set -e
  if [ $? -ne 0 ]; then
    sudo apt-get -y update
    sudo apt-get -y clean
    sudo apt-get install -y git libmysqlclient-dev libpq-dev libsqlite3-dev
  fi

  set +e
  sudo which gem > /dev/null 2>&1
  set -e
  if [ $? -eq 0 ]; then
    sudo gem install bundler --no-ri --no-rdoc
  else
    gem install bundler --no-ri --no-rdoc
  fi

  if [ ! -d 'bosh' ]; then
    git clone --depth=1 https://github.com/cloudfoundry/bosh.git
  fi

  cd bosh
  git checkout master
  git pull
  git submodule update --init --recursive
  bundle install

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
  stemcell:
    name: bosh-warden-boshlite-ubuntu-trusty-go_agent
    version: latest
  instances: 1
  mbus: nats://nats:nats-password@10.254.50.4:4222
EOF
  cat bat.spec

  export BAT_DEPLOYMENT_SPEC=`pwd`/bat.spec
  export BAT_DIRECTOR=$director_ip
  export BAT_DNS_HOST=$director_ip
  export BAT_VCAP_PASSWORD=c1oudc0w
  export BAT_INFRASTRUCTURE=warden

  cd bat
  bundle exec rake bat || bundle exec rake bat # remove after monit issue is fixed

  rm -f $config_file
}

run_bats_against() {
  set -e

  director_ip=$1

  if [ ! -d 'bosh' ]; then
    git clone --depth=1 https://github.com/cloudfoundry/bosh.git
  fi

  ( run_bats $director_ip )
}

run_bats_on_vm() {
  set -e
  vagrant ssh -c "$(declare -f run_bats); run_bats 127.0.0.1"
}

publish_vagrant_box() {
  set -e

  box_type=$1
  candidate_build_number=$2
  s3cmd put -P bosh-lite-$box_type-ubuntu-trusty-$candidate_build_number.box s3://bosh-lite-build-artifacts/
}
