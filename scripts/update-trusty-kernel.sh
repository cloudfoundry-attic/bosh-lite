#!/bin/bash

set -e

apt-get -y --force-yes install linux-generic

reboot
sleep 60
