#!/bin/bash

(cat <<PROFILE
export TMPDIR=${HOME}/tmp
PROFILE
) >> $HOME/.profile

mkdir -p $HOME/tmp