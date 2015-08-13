#!/bin/bash

set -ex

apt-get -y install ruby2.0

ln -sf /usr/bin/ruby2.0 /usr/bin/ruby
