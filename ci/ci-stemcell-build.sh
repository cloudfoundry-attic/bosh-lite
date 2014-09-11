#!/usr/bin/env bash
set -ex

export STEMCELL_BUILD_NUMBER=${BOSH_LITE_CANDIDATE_BUILD_NUMBER}

source $(dirname $0)/test_helpers.sh

trap cleanup EXIT

rm -rf output

fetch_latest_bosh

(
  cd bosh
  bundle exec rake stemcell:build[warden,ubuntu,trusty,go,bosh-os-images,bosh-ubuntu-trusty-os-image.tgz]
)

mkdir -p output
cp /mnt/stemcells/warden/boshlite/ubuntu/work/work/*.tgz output/
