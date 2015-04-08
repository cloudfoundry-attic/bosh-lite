#!/usr/bin/env bash

set -e -x

# wire up virtualbox capabilities
# todo vmware workstation?
function enable_local_vbox() {
  # create vboxdrv device
  mknod -m 0600 /dev/vboxdrv c 10 58
  mknod -m 0666 /dev/vboxdrvu c 10 57
  mknod -m 0600 /dev/vboxnetctl c 10 56
}
