#!/usr/bin/env bash

set -e -x

source $(dirname $0)/lib/global-env.sh

box_version=$(cat box-version/number)

BOSH_RELEASE_VERSION=$(cat bosh-release/version)
WARDEN_RELEASE_VERSION=$(cat bosh-warden-cpi-release/version)

cp bosh-release/*.tgz bosh-lite/bosh-release.tgz
cp bosh-warden-cpi-release/*.tgz bosh-lite/bosh-warden-cpi-release.tgz

cd bosh-lite

export AWS_ACCESS_KEY_ID=$BOSH_AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$BOSH_AWS_SECRET_ACCESS_KEY

./bin/build-aws \
  $BOSH_RELEASE_VERSION \
  $WARDEN_RELEASE_VERSION \
  $box_version | tee output

ami=`tail -2 output | grep -Po "ami-.*"`

sleep 60

aws ec2 modify-image-attribute \
  --image-id $ami \
  --launch-permission "{\"Add\": [{\"Group\":\"all\"}]}"
