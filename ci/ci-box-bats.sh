#!/usr/bin/env bash
set -ex

source $(dirname $0)/test_helpers.sh

trap cleanup EXIT

clean_vagrant

sed -i'' -e "s/\.box = .*/.box = 'bosh-lite-ubuntu-trusty-$BOX_TYPE-$BOSH_LITE_CANDIDATE_BUILD_NUMBER'/" Vagrantfile
PRIVATE_NETWORK_IP=${PRIVATE_NETWORK_IP:-192.168.50.4}
sed -i'' -e "s/# override\.vm\.network :private_network, ip: '192\.168\.54\.4', id: :local/override.vm.network :private_network, ip: '$PRIVATE_NETWORK_IP', id: :local/" Vagrantfile
cat Vagrantfile
sed -i'' -e "s/192.168.50.4/$PRIVATE_NETWORK_IP/" bin/add-route
cat bin/add-route

box_add_and_vagrant_up $BOX_TYPE $PROVIDER $BOSH_LITE_CANDIDATE_BUILD_NUMBER

./bin/add-route || true
run_bats_against $PRIVATE_NETWORK_IP
