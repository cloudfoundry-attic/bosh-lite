#!/bin/bash

set -e

(cat <<PROFILE
export TMPDIR=${HOME}/tmp
PROFILE
) >> $HOME/.profile

mkdir -p $HOME/tmp
chown -R ubuntu:ubuntu $HOME/tmp
