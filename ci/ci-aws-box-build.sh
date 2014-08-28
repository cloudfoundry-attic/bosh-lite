set -x
set -e

PACKER_LOG=1
. ~/.awskey

./bin/build-aws ${BOSH_RELEASE_VERSION} ${BOSH_RELEASE_BUILD_NUMBER} ${WARDEN_RELEASE_VERSION} ${BUILD_NUMBER} | tee output

ami=`tail -2 output | grep -Po "ami-.*"`

sleep 60
ec2-modify-image-attribute $ami  --launch-permission -a all --aws-access-key $AWS_ACCESS_KEY_ID --aws-secret-key $AWS_SECRET_ACCESS_KEY

s3cmd get --force s3://bosh-lite-build-artifacts/ami/bosh-lite-ami.list bosh-lite-ami.list
echo $ami >> bosh-lite-ami.list
s3cmd put -P  bosh-lite-ami.list s3://bosh-lite-build-artifacts/ami/bosh-lite-ami.list

