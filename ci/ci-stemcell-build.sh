#!/bin/bash -l
set -e
. ~/.bashrc
PATH=/var/lib/jenkins/.rbenv/shims:/var/lib/jenkins/.rbenv/bin:$PATH
export STEMCELL_BUILD_NUMBER=${BUILD_NUMBER}

echo $STEMCELL_BUILD_NUMBER

rm -rf bosh
git clone https://github.com/cloudfoundry/bosh.git

(
  cd bosh
  git submodule update --init --recursive

  bundle install
  bundle exec rake stemcell:build[warden,ubuntu,trusty,go,bosh-os-images,bosh-ubuntu-trusty-os-image.tgz]
)

mkdir output || true
cp /mnt/stemcells/warden/boshlite/ubuntu/work/work/*.tgz ./output/
