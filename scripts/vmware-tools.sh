#!/bin/bash

set -ex

apt-get install -y linux-headers-$(uname -r) build-essential make perl dkms

mount -o loop /home/vagrant/linux.iso /media/cdrom

cd /tmp
tar zxf /media/cdrom/VMwareTools-*.tar.gz -C .
/tmp/vmware-tools-distrib/vmware-install.pl -d

rm /home/vagrant/linux.iso
umount /media/cdrom

apt-get remove -y linux-headers-$(uname -r)
