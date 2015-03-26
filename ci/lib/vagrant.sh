#!/usr/bin/env bash

set -e -x

# todo needed?
export TERM=xterm

# todo only cleanup when did vagrant up?
trap clean_vagrant EXIT

set_up_vagrant_private_key() {
  if [ ! -f "$BOSH_LITE_PRIVATE_KEY" ]; then
    key_path=$(mktemp -d /tmp/ssh_key.XXXXXXXXXX)/value
    echo "$BOSH_LITE_PRIVATE_KEY" > $key_path
    chmod 600 $key_path
    export BOSH_LITE_PRIVATE_KEY=$key_path
  fi
}

clean_vagrant() {
  ( cd /tmp/build/src/bosh-lite && vagrant destroy -f || true )
}

# todo box_type vs provider
box_add_and_vagrant_up() {
  box_file=$1
  box_type=$2
  provider=$3
  box_version=$4

  vagrant box add \
    $box_file \
    --name bosh-lite-ubuntu-trusty-${box_type}-${box_version} \
    --force

  # vagrant will bring up needed host only networks
  if [ "$box_type" = "virtualbox" ]; then
    VBoxManage hostonlyif remove vboxnet0 || true
    VBoxManage hostonlyif remove vboxnet1 || true
  fi

  vagrant up --provider=$provider
}
