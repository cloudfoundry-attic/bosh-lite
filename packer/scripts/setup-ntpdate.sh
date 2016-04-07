#!/usr/bin/env bash

set -ex

echo '*/15 * * * * root ntpdate ntp.ubuntu.com' >> /etc/crontab
