#!/usr/bin/env bash

set -ex

source $(dirname $0)/test_helpers.sh

reset() {
  git reset --hard @{u}
}

trap reset EXIT

publish_vagrant_box aws $BOSH_LITE_CANDIDATE_BUILD_NUMBER
publish_vagrant_box vmware $BOSH_LITE_CANDIDATE_BUILD_NUMBER
publish_vagrant_box virtualbox $BOSH_LITE_CANDIDATE_BUILD_NUMBER

sed -i'' -e "s/[0-9]+\.box/${BOSH_LITE_CANDIDATE_BUILD_NUMBER}.box/" Vagrantfile
git diff
git add Vagrantfile
git commit -m "Update box versions to $BOSH_LITE_CANDIDATE_BUILD_NUMBER"
git push origin HEAD:master

git fetch origin develop
git merge develop -m "Merge build ${CANDIDATE_BUILD_NUMBER} to develop"
git push origin HEAD:develop
