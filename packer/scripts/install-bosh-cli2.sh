#!/bin/bash

set -ex

rm /var/vcap/bosh/etc/gemrc
gem install bosh_cli --no-ri --no-rdoc

(cat <<BOSH_CONFIG
auth:
  https://127.0.0.1:25555:
    username: admin
    password: admin
BOSH_CONFIG
) > $HOME/.bosh_config

bosh target 127.0.0.1
