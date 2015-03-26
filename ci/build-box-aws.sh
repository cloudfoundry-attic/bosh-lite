#!/usr/bin/env bash

set -e -x

box_version=$(cat box-version/number)

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
