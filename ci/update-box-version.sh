#!/usr/bin/env bash

set -e -x

source $(dirname $0)/lib/global-env.sh

box_version=$(cat box-version/number)

cd bosh-lite

sed \
  -i \
  -e "s/override.vm.box_version = '.*' # ci:replace/override.vm.box_version = '${box_version}' # ci:replace/" \
  Vagrantfile

if [ -z "$(git diff --name-only Vagrantfile)" ]; then
  # nothing to do
  exit 0
fi

git diff | cat

git add Vagrantfile

git config --global user.email "cf-bosh-eng@pivotal.io"
git config --global user.name "CI"
git commit -m "Update box version to $box_version"

git clone ../bosh-lite ../bosh-lite-out
