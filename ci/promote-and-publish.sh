#!/usr/bin/env bash

set -ex

reset() {
  git reset --hard HEAD
}

trap reset EXIT

create_vagrant_cloud_version(){
  result=`curl https://vagrantcloud.com/api/v1/box/cloudfoundry/bosh-lite/versions \
          -X POST \
          -d version[version]="$BOSH_LITE_CANDIDATE_BUILD_NUMBER" \
          -d access_token="$VAGRANT_CLOUD_ACCESS_TOKEN"`
  version_id=`echo $result | jq ".number"`

  if [ "$version_id" = "null" ]; then
    echo "Failed to create version"
    exit 1
  fi
  echo $version_id
}

publish_to_s3(){
  for provider in "virtualbox" "aws" "vmware"; do
    publish_vagrant_box_to_s3 $provider $BOSH_LITE_CANDIDATE_BUILD_NUMBER
  done
}

publish_to_vagrant_cloud(){
  version_id=`create_vagrant_cloud_version`

  for provider in "virtualbox" "aws"; do
    upload_box_to_vagrant_cloud $provider $provider $version_id
  done

  for provider in "vmware_fusion" "vmware_workstation" "vmware_desktop"; do
    upload_box_to_vagrant_cloud $provider "vmware" $version_id
  done

  curl https://vagrantcloud.com/api/v1/box/cloudfoundry/bosh-lite/version/${version_id}/release -X PUT -d access_token="$VAGRANT_CLOUD_ACCESS_TOKEN"  
}

update_vagrant_file() {
  sed -i'' -e "s/config.vm.box_version = '.*'/config.vm.box_version = '$BOSH_LITE_CANDIDATE_BUILD_NUMBER'/" Vagrantfile
  git diff
  git add Vagrantfile
  git commit -m "Update box version to $BOSH_LITE_CANDIDATE_BUILD_NUMBER"
  git push origin HEAD:master

  git fetch origin develop
  git merge origin/develop -m "Merge build ${BOSH_LITE_CANDIDATE_BUILD_NUMBER} to develop"
  git push origin HEAD:develop
}

upload_box_to_vagrant_cloud() {
  provider=$1
  box_type=$2
  version_id=$3

  curl https://vagrantcloud.com/api/v1/box/cloudfoundry/bosh-lite/version/${version_id}/providers \
  -X POST \
  -d provider[name]="$provider" \
  -d provider[url]="http://d3a4sadvqj176z.cloudfront.net/bosh-lite-$box_type-ubuntu-trusty-$BOSH_LITE_CANDIDATE_BUILD_NUMBER.box" \
  -d access_token="$VAGRANT_CLOUD_ACCESS_TOKEN"
}

publish_vagrant_box_to_s3() {
  box_type=$1
  candidate_build_number=$2
  box_name="bosh-lite-${box_type}-ubuntu-trusty-${candidate_build_number}.box"

  s3cmd --access_key=$BOSH_AWS_ACCESS_KEY_ID --secret_key=$BOSH_AWS_SECRET_ACCESS_KEY mv s3://bosh-lite-ci-pipeline/$box_name s3://bosh-lite-build-artifacts/$box_name
}

main(){
  if [ -z "${VAGRANT_CLOUD_ACCESS_TOKEN}" ]; then
    echo "VAGRANT_CLOUD_ACCESS_TOKEN needs to be set"
    exit 1
  fi

  if [ -z "${BOSH_LITE_CANDIDATE_BUILD_NUMBER}" ]; then
    echo "BOSH_LITE_CANDIDATE_BUILD_NUMBER needs to be set"
    exit 1
  fi
  
  publish_to_s3
  publish_to_vagrant_cloud
  update_vagrant_file
}

main
