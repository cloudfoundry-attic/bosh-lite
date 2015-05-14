#!/bin/bash

set -e

sudo gem install bosh_cli --no-ri --no-rdoc

(cat <<BOSH_CONFIG
auth:
  https://127.0.0.1:25555:
    username: admin
    password: admin
BOSH_CONFIG
) > $HOME/.bosh_config

bosh target 127.0.0.1
chown $USER:$USER $HOME/.bosh_config

wget "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" -O /tmp/cf-cli.tgz
tar xf /tmp/cf-cli.tgz -C /tmp
sudo mv /tmp/cf /usr/local/bin/
