#!/usr/bin/env bash
set -ex

source $(dirname $0)/test_helpers.sh

trap cleanup EXIT

clean_vagrant

vagrant up --provider=virtualbox

rm -rf output

./bin/add-route || true

export BAT_STEMCELL=$(pwd)/bosh-stemcell-$BOSH_LITE_CANDIDATE_BUILD_NUMBER-warden-boshlite-$STEMCELL_OS_NAME-go_agent.tgz
run_bats_against 192.168.50.4 $STEMCELL_OS_NAME

mkdir -p output
mv bosh-stemcell-$BOSH_LITE_CANDIDATE_BUILD_NUMBER-warden-boshlite-$STEMCELL_OS_NAME-go_agent.tgz output/
