#!/usr/bin/env bash

set -x -e

source $(dirname $0)/lib/vagrant.sh

box_version=$(cat box-version/number)
box_file=$(ls $PWD/box/*.box)

cd bosh-lite

sed -e "s/BOSH_LITE_CANDIDATE_BUILD_NUMBER/$box_version/" ci/Vagrantfile.aws > Vagrantfile
cat Vagrantfile

set_up_vagrant_private_key

box_add_and_vagrant_up $box_file aws aws $box_version

# todo remove installation
gem install bosh_cli --no-ri --no-rdoc

# Install spiff
wget https://github.com/cloudfoundry-incubator/spiff/releases/download/v1.0.3/spiff_linux_amd64.zip -O /tmp/spiff.zip
unzip /tmp/spiff.zip -d /tmp
sudo mv /tmp/spiff /usr/local/bin/

git clone --depth=1 https://github.com/cloudfoundry/cf-release.git ../cf-release

bin/provision_cf
