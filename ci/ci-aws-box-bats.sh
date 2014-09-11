#!/usr/bin/env bash
set -ex

source $(dirname $0)/test_helpers.sh

trap cleanup EXIT

clean_vagrant

sed -i'' -e "s/\.box = .*/.box = 'bosh-lite-ubuntu-trusty-aws-$BOSH_LITE_CANDIDATE_BUILD_NUMBER'/" Vagrantfile
cat Vagrantfile

box_add_and_vagrant_up aws aws $BOSH_LITE_CANDIDATE_BUILD_NUMBER

run_bats_on_vm
