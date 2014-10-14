#!/usr/bin/env bash
set -ex

export STEMCELL_BUILD_NUMBER=${BOSH_LITE_CANDIDATE_BUILD_NUMBER}

source $(dirname $0)/test_helpers.sh

trap cleanup EXIT

rm -rf output

fetch_latest_bosh

(
  cd bosh
  bundle exec rake stemcell:build[warden,boshlite,$OS_NAME,$OS_VERSION,go,bosh-os-images,bosh-$OS_NAME-$OS_VERSION-os-image.tgz]
)

mkdir -p output
cp /mnt/stemcells/warden/boshlite/$OS_NAME/work/work/*.tgz output/
