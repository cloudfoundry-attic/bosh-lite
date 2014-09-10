#!/usr/bin/env bash

set -xe

cleanup() {
  set +e
  vagrant destroy -f
}

trap cleanup EXIT

vagrant up --provider=virtualbox

set +e
bin/add-route
set -e

bin/provision_cf

