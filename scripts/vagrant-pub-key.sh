#!/bin/bash

set -ex

mkdir -p ~/.ssh

wget -qO- https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub >> ~/.ssh/authorized_keys
