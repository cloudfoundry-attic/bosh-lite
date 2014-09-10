#!/usr/bin/env bash
set -ex

source $(dirname $0)/test_helpers.sh

trap cleanup EXIT

clean_vagrant

vagrant up --provider=virtualbox

rm -rf output

export BAT_STEMCELL=$(pwd)/bosh-stemcell-$CANDIDATE_BUILD_NUMBER-warden-boshlite-ubuntu-trusty-go_agent.tgz
run_bats_against 192.168.50.4

mkdir -p output
mv bosh-stemcell-$CANDIDATE_BUILD_NUMBER-warden-boshlite-ubuntu-trusty-go_agent.tgz output/
