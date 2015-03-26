#!/usr/bin/env bash

set -e -x

source $(dirname $0)/vagrant.sh
source $(dirname $0)/vbox.sh
source $(dirname $0)/bats.sh

cd bosh-lite

vagrant up --provider=virtualbox

./bin/add-route || true

STEMCELL="bosh-stemcell-${BOSH_LITE_CANDIDATE_BUILD_NUMBER}-warden-boshlite-${STEMCELL_OS_NAME}-go_agent.tgz"
wget "https://bosh-lite-ci-pipeline.s3.amazonaws.com/${BOSH_LITE_CANDIDATE_BUILD_NUMBER}/bosh-stemcell/warden/${STEMCELL}"

export BAT_STEMCELL=$PWD/$STEMCELL
run_bats 192.168.50.4 $STEMCELL_OS_NAME
