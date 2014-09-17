#!/usr/bin/env bash

set -ex

source $(dirname $0)/test_helpers.sh

if [ -z "${VAGRANT_CLOUD_ACCESS_TOKEN}" ]; then
  echo "VAGRANT_CLOUD_ACCESS_TOKEN needs to be set"
  exit 1
fi

reset() {
  git reset --hard HEAD
}

trap reset EXIT

upload_box() {
  provider=$1
  box_type=$2

  curl https://vagrantcloud.com/api/v1/box/BOSH/bosh-lite-ubuntu-trusty/version/${version_id}/providers \
  -X POST \
  -d provider[name]="$provider" \
  -d provider[url]="https://s3.amazonaws.com/bosh-lite-build-artifacts/bosh-lite-$box_type-ubuntu-trusty-$BOSH_LITE_CANDIDATE_BUILD_NUMBER.box" \
  -d access_token="$VAGRANT_CLOUD_ACCESS_TOKEN"
}

publish_vagrant_box aws $BOSH_LITE_CANDIDATE_BUILD_NUMBER
publish_vagrant_box vmware $BOSH_LITE_CANDIDATE_BUILD_NUMBER
publish_vagrant_box virtualbox $BOSH_LITE_CANDIDATE_BUILD_NUMBER

result=`curl https://vagrantcloud.com/api/v1/box/BOSH/bosh-lite-ubuntu-trusty/versions \
        -X POST \
        -d version[version]="$BOSH_LITE_CANDIDATE_BUILD_NUMBER" \
        -d access_token="$VAGRANT_CLOUD_ACCESS_TOKEN"`
version_id=`echo $result | jq ".number"`

if [ "$version_id" = "null" ]; then
  echo "Failed to create version"
  exit 1
fi

for provider in "virtualbox" "aws"; do
  upload_box $provider $provider
done

for provider in "vmware_fusion" "vmware_workstation" "vmware_desktop"; do
  upload_box $provider "vmware"
done

curl https://vagrantcloud.com/api/v1/box/BOSH/bosh-lite-ubuntu-trusty/version/${version_id}/release -X PUT -d access_token="$VAGRANT_CLOUD_ACCESS_TOKEN"

# sed -i'' -e "s/config.vm.box_version = '.*'/config.vm.box_version = '$BOSH_LITE_CANDIDATE_BUILD_NUMBER'/" Vagrantfile
# git diff
# git add Vagrantfile
# git commit -m "Update box version to $BOSH_LITE_CANDIDATE_BUILD_NUMBER"
# git push origin HEAD:master
#
# git fetch origin develop
# git merge develop -m "Merge build ${CANDIDATE_BUILD_NUMBER} to develop"
# git push origin HEAD:develop
