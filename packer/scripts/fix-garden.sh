#!/bin/bash

set -ex

truncate -s 10M /tmp/garden-disk
mkfs -t ext4 -F /tmp/garden-disk

mkdir -p /var/vcap/data/garden/aufs_graph/
mount /tmp/garden-disk /var/vcap/data/garden/aufs_graph/
