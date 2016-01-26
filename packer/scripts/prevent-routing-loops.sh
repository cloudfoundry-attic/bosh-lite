#!/bin/bash

set -e

sudo DEBIAN_FRONTEND=noninteractive apt-get install iptables-persistent
sudo iptables -I FORWARD 1 -p all -o eth0 -d 10.244.0.0/16 -j DROP
sudo /bin/bash -c "iptables-save > /etc/iptables/rules.v4"
