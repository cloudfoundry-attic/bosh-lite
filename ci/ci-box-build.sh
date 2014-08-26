#!/bin/bash -l
set -x
set -e

PACKER_LOG=1

git submodule update --init --recursive

if [ -f '/var/lib/jenkins/VirtualBox VMs/packer-virtualbox-iso/packer-virtualbox-iso.vbox' ] ; then
  VBoxManage modifyvm packer-virtualbox-iso --natpf1 delete packerssh || true
  VBoxManage unregistervm packer-virtualbox-iso --delete || true
  rm -f '/var/lib/jenkins/VirtualBox VMs/packer-virtualbox-iso/packer-virtualbox-iso.vbox'
fi

./bin/build-vbox ${BOSH_RELEASE_VERSION} ${BOSH_RELEASE_BUILD_NUMBER} ${WARDEN_RELEASE_VERSION}

vagrant box add bosh-lite-virtualbox-ubuntu-14-04-0.box --name boshlite-ubuntu1404 --force

s3cmd put -P *.box s3://bosh-lite-build-artifacts/${BUILD_NUMBER}/
s3cmd cp -P --recursive s3://bosh-lite-build-artifacts/${BUILD_NUMBER}/ s3://bosh-lite-build-artifacts/current/
