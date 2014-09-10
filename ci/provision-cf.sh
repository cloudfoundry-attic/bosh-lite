#!/usr/bin/env bash

set -xe

cleanup() {
  set +e
  vagrant destroy -f
}

trap cleanup EXIT

vagrant up --provider=virtualbox

bin/add-route

bin/provision_cf

