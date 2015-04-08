#!/usr/bin/env bash

set -e -x

source $(dirname $0)/lib/global-env.sh
source $(dirname $0)/lib/vbox.sh

box_version=$(cat box-version/number)

BOSH_RELEASE_VERSION=$(cat bosh-release/version)
WARDEN_RELEASE_VERSION=$(cat bosh-warden-cpi-release/version)

cp bosh-release/*.tgz bosh-lite/bosh-release.tgz
cp bosh-warden-cpi-release/*.tgz bosh-lite/bosh-warden-cpi-release.tgz

cd bosh-lite

enable_local_vbox

./bin/build-$BOX_TYPE \
	$BOSH_RELEASE_VERSION \
	$WARDEN_RELEASE_VERSION \
	$box_version
