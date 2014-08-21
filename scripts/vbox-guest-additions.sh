#!/bin/bash

set -ex

apt-get install -y linux-headers-$(uname -r) build-essential make perl dkms puppet-common
apt-get -y clean

#VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
mount -o loop /home/vagrant/VBoxGuestAdditions.iso /media/cdrom
# Ignore X driver failure, we don't need it
/media/cdrom/VBoxLinuxAdditions.run || true
umount /media/cdrom

#rm /tmp/VBoxGuestAdditions.iso
