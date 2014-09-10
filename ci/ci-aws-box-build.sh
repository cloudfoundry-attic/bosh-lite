#!/usr/bin/env bash
set -ex

# Clean up old box files
rm -rf *.box

PACKER_LOG=1

./bin/build-aws ${BOSH_RELEASE_VERSION} ${BOSH_RELEASE_BUILD_NUMBER} ${WARDEN_RELEASE_VERSION} ${BUILD_NUMBER} | tee output

ami=`tail -2 output | grep -Po "ami-.*"`

sleep 60
ec2-modify-image-attribute $ami  --launch-permission -a all --aws-access-key $AWS_ACCESS_KEY_ID --aws-secret-key $AWS_SECRET_ACCESS_KEY
