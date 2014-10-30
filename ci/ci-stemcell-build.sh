#!/usr/bin/env bash
set -ex

export STEMCELL_BUILD_NUMBER=${BOSH_LITE_CANDIDATE_BUILD_NUMBER}
export TMPDIR="/var/vcap/data/tmp"

source $(dirname $0)/test_helpers.sh

trap cleanup EXIT

rm -rf $TMPDIR
rm -rf output

mkdir -p $TMPDIR

chruby 2.1.2

fetch_latest_bosh

(
  cd bosh
  bundle exec rake ci:publish_stemcell_in_vm[warden,boshlite,$OS_NAME,$OS_VERSION,remote,go,bosh-os-images,bosh-$OS_NAME-$OS_VERSION-os-image.tgz,bosh-lite-ci-pipeline]
)

mkdir -p output
cp /mnt/stemcells/warden/boshlite/$OS_NAME/work/work/*.tgz output/
