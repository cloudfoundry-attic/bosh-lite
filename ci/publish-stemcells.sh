#!/usr/bin/env bash

set -e -x

s3_cmd_cp() {
  s3cmd \
    --access_key=$BOSH_AWS_ACCESS_KEY_ID \
    --secret_key=$BOSH_AWS_SECRET_ACCESS_KEY \
    --mime-type=application/x-gtar \
    --no-preserve -P cp $1 $2
}

main() {
  pipeline_bucket="s3://test-bosh-lite-bucket/$BOSH_LITE_CANDIDATE_BUILD_NUMBER/bosh-stemcell/warden"
  stemcell_bucket="s3://test-bosh-lite-stemcells"

  for os in "ubuntu-trusty" "centos"; do
    stemcell="bosh-stemcell-${BOSH_LITE_CANDIDATE_BUILD_NUMBER}-warden-boshlite-${os}-go_agent.tgz"
    s3_cmd_cp "${pipeline_bucket}/${stemcell}" "${stemcell_bucket}/"
    s3_cmd_cp "${pipeline_bucket}/${stemcell}" "${stemcell_bucket}/latest-bosh-stemcell-warden-${os}-go_agent.tgz"
  done

  # trusty is the default ubuntu stemcell
  stemcell="bosh-stemcell-${BOSH_LITE_CANDIDATE_BUILD_NUMBER}-warden-boshlite-ubuntu-trusty-go_agent.tgz"
  s3_cmd_cp "${pipeline_bucket}/${stemcell}" "${stemcell_bucket}/latest-bosh-stemcell-warden-ubuntu.tgz"
  s3_cmd_cp "${pipeline_bucket}/${stemcell}" "${stemcell_bucket}/latest-bosh-stemcell-warden.tgz"
}

main
