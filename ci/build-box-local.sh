#!/usr/bin/env bash

set -e -x

source $(dirname $0)/lib/vbox.sh

box_version=$(cat box-version/number)

cd bosh-lite

enable_local_vbox

./bin/build-$BOX_TYPE \
	$BOSH_RELEASE_VERSION \
	$WARDEN_RELEASE_VERSION \
	$box_version
