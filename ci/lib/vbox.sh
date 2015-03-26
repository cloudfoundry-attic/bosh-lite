#!/usr/bin/env bash

set -e -x

# wire up virtualbox capabilities
# todo vmware workstation?
function enable_local_vbox() {
  # permit usage of vboxdrv node by tacking it into our own cgroup
  mkdir /tmp/devices-cgroup
  mount -t cgroup -o devices none /tmp/devices-cgroup
  mountpoint -q /sys || mount -t sysfs none /sys
  echo 'c 10:57 rwm' > /tmp/devices-cgroup/instance-$(hostname)/devices.allow
  echo 'c 10:55 rwm' > /tmp/devices-cgroup/instance-$(hostname)/devices.allow

  # create vboxdrv device
  mknod -m 0600 /dev/vboxdrv c 10 57
  mknod -m 0600 /dev/vboxnetctl c 10 55
}
