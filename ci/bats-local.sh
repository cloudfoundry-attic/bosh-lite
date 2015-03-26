#!/usr/bin/env bash

set -e -x

source $(dirname $0)/lib/vagrant.sh
source $(dirname $0)/lib/vbox.sh
source $(dirname $0)/lib/bats.sh

box_version=$(cat box-version/number)
box_file=$(ls $PWD/box/*.box)

cd bosh-lite

enable_local_vbox

private_net_ip=${PRIVATE_NETWORK_IP:-192.168.50.4}

sed -e "s/BOSH_LITE_CANDIDATE_BUILD_NUMBER/$box_version/" ci/Vagrantfile.$BOX_TYPE > Vagrantfile

sed -i'' -e "s/PRIVATE_NETWORK_IP/$private_net_ip/" Vagrantfile
cat Vagrantfile

sed -i'' -e "s/192.168.50.4/$private_net_ip/" bin/add-route
cat bin/add-route

box_add_and_vagrant_up $box_file $BOX_TYPE $PROVIDER $box_version

./bin/add-route || true

run_bats $private_net_ip ubuntu-trusty
