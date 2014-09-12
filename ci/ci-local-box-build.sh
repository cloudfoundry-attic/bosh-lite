#!/usr/bin/env bash
set -ex

git submodule update --init --recursive

PACKER_LOG=1

# Clean up old box files
rm -rf *.box

if [ -f '/var/lib/jenkins/VirtualBox VMs/packer-virtualbox-iso/packer-virtualbox-iso.vbox' ] ; then
  VBoxManage modifyvm packer-virtualbox-iso --natpf1 delete packerssh || true
  VBoxManage unregistervm packer-virtualbox-iso --delete || true
  rm -f '/var/lib/jenkins/VirtualBox VMs/packer-virtualbox-iso/packer-virtualbox-iso.vbox'
fi

./bin/build-${BOX_TYPE} ${BOSH_RELEASE_VERSION} ${BOSH_RELEASE_BUILD_NUMBER} ${WARDEN_RELEASE_VERSION} ${BOSH_LITE_CANDIDATE_BUILD_NUMBER}
