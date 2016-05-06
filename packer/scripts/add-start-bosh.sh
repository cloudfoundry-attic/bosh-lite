#!/bin/bash

set -ex

cat > /usr/bin/start-bosh <<BASH
#!/bin/bash
set -ex

# Aufs on aufs doesnt work
truncate -s 10G /tmp/garden-disk
mkfs -t ext4 -F /tmp/garden-disk

mkdir -p /var/vcap/data/garden/aufs_graph/
mount /tmp/garden-disk /var/vcap/data/garden/aufs_graph/

# Global package cache configuration
mkdir -p /vagrant
chmod 777 /vagrant

# Start agent & monit
exec /usr/sbin/runsvdir-start <&- >/dev/null 2>&1
BASH

chmod 755 /usr/bin/start-bosh
chown root:root /usr/bin/start-bosh
