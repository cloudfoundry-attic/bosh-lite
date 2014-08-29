#!/bin/bash -l
set -x
set -e

git submodule update --init --recursive

PACKER_LOG=1

# Clean up old box files
rm -rf *.box

if [ -f '/var/lib/jenkins/VirtualBox VMs/packer-virtualbox-iso/packer-virtualbox-iso.vbox' ] ; then
  VBoxManage modifyvm packer-virtualbox-iso --natpf1 delete packerssh || true
  VBoxManage unregistervm packer-virtualbox-iso --delete || true
  rm -f '/var/lib/jenkins/VirtualBox VMs/packer-virtualbox-iso/packer-virtualbox-iso.vbox'
fi

./bin/build-${BOX_TYPE} ${BOSH_RELEASE_VERSION} ${BOSH_RELEASE_BUILD_NUMBER} ${WARDEN_RELEASE_VERSION} ${BUILD_NUMBER}

vagrant box add bosh-lite-${BOX_TYPE}-ubuntu-trusty-${BUILD_NUMBER}.box --name bosh-lite-virtualbox-ubuntu-trusty --force
