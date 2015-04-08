#!/usr/bin/env bash

# shim these in for garden-systemd (doesn't support ENV rules)
# paths are correct for the bosh-lite-ci docker image
export GOPATH=/opt/local/go
export PATH=/opt/local/bin:/opt/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PACKER_CONFIG=/opt/local/packerconfig
export HOME=${HOME:-/root}
