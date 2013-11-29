#!/bin/sh
# vim: set ft=sh

set -e

echo "Targeting director and logging in..."
bosh -n target 192.168.50.4
bosh -n login admin admin

echo "Preparing manifest..."
DIRECTOR_UUID=$(bosh status | grep UUID | awk '{print $2}')

cat > ~/cf-deployment-stub.yml <<EOF
name: cf-warden
director_uuid: $DIRECTOR_UUID
releases:
  - name: cf
    version: latest
EOF

pushd ~/workspace/cf-release
  ./generate_deployment_manifest warden ~/cf-deployment-stub.yml > ~/cf-deployment.yml
  bosh deployment ~/cf-deployment.yml
popd

echo "All set!"
echo "Deploy like usual from cf-release."
