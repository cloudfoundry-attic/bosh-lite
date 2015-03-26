#!/usr/bin/env bash

set -e -x

git clone --depth=1 https://github.com/cloudfoundry/bosh.git

cd bosh

# Make .git/modules available
git submodule update --init

bundle

cd bosh-stemcell

bundle exec rake ci:publish_stemcell_in_vm[warden,boshlite,$OS_NAME,$OS_VERSION,remote,go,bosh-os-images,bosh-$OS_NAME-$OS_VERSION-os-image.tgz,test-bosh-lite-bucket]
