#!/usr/bin/env bash
set -ex

source $(dirname $0)/test_helpers.sh
source $(dirname $0)/ci_helpers.sh

trap cleanup EXIT

chruby 2.1.2

clean_vagrant

sed -e "s/BOSH_LITE_CANDIDATE_BUILD_NUMBER/$BOSH_LITE_CANDIDATE_BUILD_NUMBER/" ci/Vagrantfile.$BOX_TYPE > Vagrantfile
PRIVATE_NETWORK_IP=${PRIVATE_NETWORK_IP:-192.168.50.4}
sed -i'' -e "s/PRIVATE_NETWORK_IP/$PRIVATE_NETWORK_IP/" Vagrantfile
cat Vagrantfile
sed -i'' -e "s/192.168.50.4/$PRIVATE_NETWORK_IP/" bin/add-route
cat bin/add-route

download_box $BOX_TYPE $BOSH_LITE_CANDIDATE_BUILD_NUMBER
box_add_and_vagrant_up $BOX_TYPE $PROVIDER $BOSH_LITE_CANDIDATE_BUILD_NUMBER

./bin/add-route || true
run_bats_against $PRIVATE_NETWORK_IP ubuntu-trusty
