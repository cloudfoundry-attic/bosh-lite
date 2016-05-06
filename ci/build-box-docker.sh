#!/usr/bin/env bash

set -ex

source $(dirname $0)/lib/global-env.sh

cp bosh-release/*.tgz            bosh-lite/packer/bosh-release.tgz
cp bosh-warden-cpi-release/*.tgz bosh-lite/packer/bosh-warden-cpi-release.tgz
cp garden-linux-release/*.tgz    bosh-lite/packer/garden-linux-release.tgz

./bosh-lite/packer/render_bosh_lite_manifest \
  $(cat bosh-release/version) \
  $(cat bosh-warden-cpi-release/version) \
  $(cat garden-linux-release/version)

box_version=$(cat box-version/number)

# Install docker binary
# todo move to the bosh-lite-ci image
apt-get -y update
apt-get -y install docker.io
chmod 777 /var/run/docker.sock

cd bosh-lite/packer

export PACKER_CONFIG=$(./fetch_packer_bosh)

packer build ./templates/docker.json -var 'build_number=$box_version'

mv bosh-lite-*.tar ../../box-out/
