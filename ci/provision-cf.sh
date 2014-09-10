#!/usr/bin/env bash

set -xe

cleanup() {
  set +e
  vagrant destroy -f
}

trap cleanup EXIT

if [ ! -d '../cf-release' ]; then
  git clone --depth=1 https://github.com/cloudfoundry/cf-release.git ../cf-release
fi

vagrant up --provider=virtualbox

set +e
bin/add-route
set -e

bin/provision_cf

