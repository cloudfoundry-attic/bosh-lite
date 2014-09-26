#!/usr/bin/env bash

set -xe

source $(dirname $0)/test_helpers.sh

trap cleanup EXIT

clean_vagrant

if [ ! -d '../cf-release' ]; then
  git clone --depth=1 https://github.com/cloudfoundry/cf-release.git ../cf-release
fi

ln -s $PWD ../bosh-lite

sed -e "s/BOSH_LITE_CANDIDATE_BUILD_NUMBER/$BOSH_LITE_CANDIDATE_BUILD_NUMBER/" ci/Vagrantfile.virtualbox > Vagrantfile
sed -i'' -e "s/PRIVATE_NETWORK_IP/192.168.50.4/" Vagrantfile
cat Vagrantfile
sed -i'' -e "s/192.168.50.4/$PRIVATE_NETWORK_IP/" bin/add-route
cat bin/add-route

box_add_and_vagrant_up $BOX_TYPE $PROVIDER $BOSH_LITE_CANDIDATE_BUILD_NUMBER

set +e
bin/add-route
set -e

bin/provision_cf

