#!/usr/bin/env bash
set -ex

env | sort

s3_cmd_cp() {
  s3cmd --access_key=$BOSH_AWS_ACCESS_KEY_ID --secret_key=$BOSH_AWS_SECRET_ACCESS_KEY --mime-type=application/x-gtar --no-preserve -P cp $1 $2
}

main() {
  PIPELINE_BUCKET="s3://bosh-lite-ci-pipeline/$BOSH_LITE_CANDIDATE_BUILD_NUMBER/bosh-stemcell/warden"
  STEMCELL_BUCKET="s3://bosh-warden-stemcells"

  for os in "ubuntu-trusty" "centos"; do
    STEMCELL="bosh-stemcell-${BOSH_LITE_CANDIDATE_BUILD_NUMBER}-warden-boshlite-${os}-go_agent.tgz"
    s3_cmd_cp "${PIPELINE_BUCKET}/${STEMCELL}" "${STEMCELL_BUCKET}/"
    s3_cmd_cp "${PIPELINE_BUCKET}/${STEMCELL}" "${STEMCELL_BUCKET}/latest-bosh-stemcell-warden-${os}-go_agent.tgz"
  done

  # trusty is the default ubuntu stemcell
  STEMCELL="bosh-stemcell-${BOSH_LITE_CANDIDATE_BUILD_NUMBER}-warden-boshlite-ubuntu-trusty-go_agent.tgz"
  s3_cmd_cp "${PIPELINE_BUCKET}/${STEMCELL}" "${STEMCELL_BUCKET}/latest-bosh-stemcell-warden-ubuntu.tgz"
  s3_cmd_cp "${PIPELINE_BUCKET}/${STEMCELL}" "${STEMCELL_BUCKET}/latest-bosh-stemcell-warden.tgz"
}

main
