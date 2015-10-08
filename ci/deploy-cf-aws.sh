#!/usr/bin/env bash

set -x -e

source $(dirname $0)/lib/global-env.sh
source $(dirname $0)/lib/vagrant.sh

box_version=$(cat box-version/number)
box_file=$(ls $PWD/box/*.box)

cd bosh-lite

sed -e "s/BOSH_LITE_CANDIDATE_BUILD_NUMBER/$box_version/" packer/templates/Vagrantfile.aws > Vagrantfile
cat Vagrantfile

set_up_vagrant_private_key

export BOSH_LITE_NAME=deploy-cf-aws-v${box_version}

box_add_and_vagrant_up $box_file aws aws $box_version

# todo remove installation
gem install net-ssh -v 2.10.0.beta2
gem install bosh_cli --no-ri --no-rdoc

# Install spiff
wget https://github.com/cloudfoundry-incubator/spiff/releases/download/v1.0.3/spiff_linux_amd64.zip -O /tmp/spiff.zip
unzip /tmp/spiff.zip -d /tmp
sudo mv /tmp/spiff /usr/local/bin/

bin/provision_cf
