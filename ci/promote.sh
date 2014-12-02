#!/usr/bin/env bash

set -ex

promote() {
  git push origin HEAD:master

  git fetch origin develop
  git merge origin/develop -m "Merge build ${BOSH_LITE_CANDIDATE_BUILD_NUMBER} to develop"
  git push origin HEAD:develop
}

main() {
  promote
}

main
