#!/bin/bash -l
set -x
set -e

git submodule update --init --recursive

PACKER_LOG=1

./bin/build-${BOX_TYPE} ${BOSH_RELEASE_VERSION} ${BOSH_RELEASE_BUILD_NUMBER} ${WARDEN_RELEASE_VERSION} ${BUILD_NUMBER}

vagrant box add bosh-lite-${BOX_TYPE}-ubuntu-14-04-${BUILD_NUMBER}.box --name bosh-lite-virtualbox-ubuntu-14-04 --force

s3cmd put -P *.box s3://bosh-lite-build-artifacts/${BUILD_NUMBER}/
s3cmd cp -P --recursive s3://bosh-lite-build-artifacts/${BUILD_NUMBER}/ s3://bosh-lite-build-artifacts/current/
