#!/usr/bin/env bash

set -e -x

source $(dirname $0)/lib/vagrant.sh
source $(dirname $0)/lib/bats.sh

box_version=$(cat box-version/number)
box_file=$(ls $PWD/box/*.box)

cd bosh-lite

sed -e "s/BOSH_LITE_CANDIDATE_BUILD_NUMBER/$box_version/" ci/Vagrantfile.aws > Vagrantfile
cat Vagrantfile

set_up_vagrant_private_key

box_add_and_vagrant_up $box_file aws aws $box_version

run_bats_on_vm ubuntu-trusty
