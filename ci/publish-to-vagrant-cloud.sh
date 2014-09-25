#!/bin/bash
set -e
set -x

if [ -z "${VAGRANT_CLOUD_ACCESS_TOKEN}" ]; then
  echo "VAGRANT_CLOUD_ACCESS_TOKEN needs to be set"
  exit 1
fi

#create release
result=`curl https://vagrantcloud.com/api/v1/box/BOSH/bosh-lite-ubuntu-trusty/versions -X POST -d version[version]="$BOSH_LITE_CANDIDATE_BUILD_NUMBER" -d access_token="$VAGRANT_CLOUD_ACCESS_TOKEN"`
number=`echo $result | jq ".number"`

if [ "$number" = "null" ]; then
  echo "Failed to create version"
  exit 1
fi

#add providers
for provider in "virtualbox" "aws"; do
  curl https://vagrantcloud.com/api/v1/box/BOSH/bosh-lite-ubuntu-trusty/version/${number}/providers \
  -X POST \
  -d provider[name]="$provider" \
  -d provider[url]="https://s3.amazonaws.com/bosh-lite-build-artifacts/bosh-lite-$provider-ubuntu-trusty-$BOSH_LITE_CANDIDATE_BUILD_NUMBER.box" \
  -d access_token="$VAGRANT_CLOUD_ACCESS_TOKEN"
done

for provider in "vmware_fusion" "vmware_workstation" "vmware_desktop"; do
  curl https://vagrantcloud.com/api/v1/box/BOSH/bosh-lite-ubuntu-trusty/version/${number}/providers -X POST -d provider[name]="$provider" -d provider[url]="https://s3.amazonaws.com/bosh-lite-build-artifacts/bosh-lite-vmware-ubuntu-trusty-$BOSH_LITE_CANDIDATE_BUILD_NUMBER.box" -d access_token="$VAGRANT_CLOUD_ACCESS_TOKEN"
done

#publish release
curl https://vagrantcloud.com/api/v1/box/BOSH/bosh-lite-ubuntu-trusty/version/${number}/release -X PUT -d access_token="$VAGRANT_CLOUD_ACCESS_TOKEN"
