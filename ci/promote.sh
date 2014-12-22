#!/usr/bin/env bash

set -ex

promote() {
  git remote rm origin
  git remote add origin 'git@github.com:cloudfoundry/bosh-lite.git'
  
  git push origin HEAD:master

  git fetch origin develop
  git merge origin/develop -m "Merge build ${BOSH_LITE_CANDIDATE_BUILD_NUMBER} to develop"
  git push origin HEAD:develop
}

main() {
  promote
}

main
