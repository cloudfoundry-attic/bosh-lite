#!/usr/bin/env bash
set -ex

env | sort

s3cmd put -P ./bosh-stemcell-$CANDIDATE_BUILD_NUMBER-warden-boshlite-ubuntu-trusty-go_agent.tgz s3://bosh-jenkins-artifacts/bosh-stemcell/warden/
s3cmd put -P ./bosh-stemcell-$CANDIDATE_BUILD_NUMBER-warden-boshlite-ubuntu-trusty-go_agent.tgz s3://bosh-jenkins-artifacts/bosh-stemcell/warden/latest-bosh-stemcell-warden-ubuntu-trusty-go_agent.tgz

# trusty is the default ubuntu stemcell
s3cmd put -P ./bosh-stemcell-$CANDIDATE_BUILD_NUMBER-warden-boshlite-ubuntu-trusty-go_agent.tgz s3://bosh-jenkins-artifacts/bosh-stemcell/warden/latest-bosh-stemcell-warden-ubuntu.tgz
s3cmd put -P ./bosh-stemcell-$CANDIDATE_BUILD_NUMBER-warden-boshlite-ubuntu-trusty-go_agent.tgz s3://bosh-jenkins-artifacts/bosh-stemcell/warden/latest-bosh-stemcell-warden.tgz
