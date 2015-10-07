#!/usr/bin/env bash

set -e -x

source $(dirname $0)/lib/global-env.sh

box_version=$(cat box-version/number)

BOSH_RELEASE_VERSION=$(cat bosh-release/version)
WARDEN_RELEASE_VERSION=$(cat bosh-warden-cpi-release/version)
GARDEN_LINUX_RELEASE_VERSION=$(cat garden-linux-release/version)

cp bosh-release/*.tgz            bosh-lite/bosh-release.tgz
cp bosh-warden-cpi-release/*.tgz bosh-lite/bosh-warden-cpi-release.tgz
cp garden-linux-release/*.tgz    bosh-lite/garden-linux-release.tgz

cd bosh-lite

export AWS_ACCESS_KEY_ID=$BOSH_AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$BOSH_AWS_SECRET_ACCESS_KEY

./packer/build-aws \
  $BOSH_RELEASE_VERSION \
  $WARDEN_RELEASE_VERSION \
  $GARDEN_LINUX_RELEASE_VERSION \
  $box_version | tee output

sleep 60

# Example:
# ap-southeast-2: ami-05baf53f
# us-west-1: ami-31cb0e75
region_to_amis=`tail -20 output | grep ': ami-'`

for region_to_ami in ${region_to_amis//: /=}; do
  region=$(echo $region_to_ami | cut -f1 -d=)
  ami=$(echo $region_to_ami | cut -f2 -d=)
  aws ec2 modify-image-attribute --region $region --image-id $ami --launch-permission "{\"Add\": [{\"Group\":\"all\"}]}"
done
