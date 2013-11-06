set -x
set -e

PACKER_LOG=1
#PACKER_LOG_PATH=/tmp/packer-box
PATH=/var/lib/jenkins/.rbenv/shims:/var/lib/jenkins/.rbenv/bin:$PATH

bundle
bundle exec librarian-chef install

killall vmware-vmx || true
if [ -f '/var/lib/jenkins/VirtualBox VMs/boshlite-virtualbox-ubuntu1204/boshlite-virtualbox-ubuntu1204.vbox' ] ; then
  VBoxManage modifyvm boshlite-virtualbox-ubuntu1204 --natpf1 delete packerssh
  VBoxManage unregistervm boshlite-virtualbox-ubuntu1204 --delete
  #rm -f /var/lib/jenkins/VirtualBox VMs/boshlite-virtualbox-ubuntu1204/boshlite-virtualbox-ubuntu1204.vbox
fi

cd boxes/
make clean
make virtualbox/boshlite-ubuntu1204.box
make vmware/boshlite-ubuntu1204.box

s3cmd put -P */*.box s3://bosh-lite-build-artifacts/${BUILD_NUMBER}/
s3cmd cp -P --recursive s3://bosh-lite-build-artifacts/${BUILD_NUMBER}/ s3://bosh-lite-build-artifacts/current/
