#!/usr/bin/env bash
set -ex

source $(dirname $0)/ci_helpers.sh

# Clean up old box files
rm -rf *.box

PACKER_LOG=1

./bin/build-aws ${BOSH_RELEASE_VERSION} ${BOSH_RELEASE_BUILD_NUMBER} ${WARDEN_RELEASE_VERSION} ${BOSH_LITE_CANDIDATE_BUILD_NUMBER} | tee output

ami=`tail -2 output | grep -Po "ami-.*"`

sleep 60
aws ec2 modify-image-attribute --image-id $ami --launch-permission "{\"Add\": [{\"Group\":\"all\"}]}"
upload_box aws $BOSH_LITE_CANDIDATE_BUILD_NUMBER
