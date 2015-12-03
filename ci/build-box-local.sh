#!/usr/bin/env bash

set -e -x

source $(dirname $0)/lib/global-env.sh
source $(dirname $0)/lib/vbox.sh

box_version=$(cat box-version/number)

BOSH_RELEASE_VERSION=$(cat bosh-release/version)
WARDEN_RELEASE_VERSION=$(cat bosh-warden-cpi-release/version)
GARDEN_LINUX_RELEASE_VERSION=$(cat garden-linux-release/version)

cp bosh-release/*.tgz            bosh-lite/packer/bosh-release.tgz
cp bosh-warden-cpi-release/*.tgz bosh-lite/packer/bosh-warden-cpi-release.tgz
cp garden-linux-release/*.tgz    bosh-lite/packer/garden-linux-release.tgz

cd bosh-lite/packer

enable_local_vbox

./build-$BOX_TYPE \
	$BOSH_RELEASE_VERSION \
	$WARDEN_RELEASE_VERSION \
	$GARDEN_LINUX_RELEASE_VERSION \
	$box_version
