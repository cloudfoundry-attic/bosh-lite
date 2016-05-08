#!/bin/bash

set -ex

cat > /usr/bin/start-bosh <<'BASH'
#!/bin/bash
set -ex

if [ ! "$BOSH_LITE_NO_AUFS" ]; then
	(
	  set -e

	  mount_path=/tmp/self-cgroups
	  cgroups_path=`cat /proc/self/cgroup|grep devices|cut -d: -f3`

	  # Clean up possibly leftover cgroups mount
	  [ -d $mount_path ] && umount $mount_path && rmdir $mount_path

	  # Make new mount for cgroups
	  mkdir -p $mount_path
	  mount -t cgroup -o devices none $mount_path

	  # Allow loop devices
	  echo 'b 7:* rwm' > $mount_path/$cgroups_path/devices.allow

	  # Clean up cgroups mount
	  umount $mount_path
	  rmdir $mount_path

	  for i in $(seq 0 260); do
	  	mknod -m660 /dev/loop${i} b 7 $i 2>/dev/null || true
	  done
	)

	# Aufs on aufs doesnt work
	truncate -s 10G /tmp/garden-disk
	mkfs -t ext4 -F /tmp/garden-disk

	mkdir -p /var/vcap/data/garden/aufs_graph/
	mount /tmp/garden-disk /var/vcap/data/garden/aufs_graph/
fi

# Global package cache configuration
mkdir -p /vagrant
chmod 777 /vagrant

# Start agent & monit
exec /usr/sbin/runsvdir-start <&- >/dev/null 2>&1
BASH

chmod 755 /usr/bin/start-bosh
chown root:root /usr/bin/start-bosh
