#!/bin/bash -l
set -x
set -e

source $(dirname $0)/test_helpers.sh

trap cleanup EXIT

clean_vagrant

sed -i'' -e "s/\.box = .*/.box = 'bosh-lite-ubuntu-trusty-aws-$CANDIDATE_BUILD_NUMBER'/" Vagrantfile
cat Vagrantfile

start_bosh_lite_vm aws aws $CANDIDATE_BUILD_NUMBER

run_bats_on_vm

publish_vagrant_box aws $CANDIDATE_BUILD_NUMBER
