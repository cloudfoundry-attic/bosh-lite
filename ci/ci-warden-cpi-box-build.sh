set -x
set -e 

PATH=/usr/local/packer/:/home/jenkins-ci/.rbenv/bin:/home/jenkins-ci/.rbenv/shims:/home/jenkins-ci/.rbenv/bin:$PATH

bundle
bundle exec librarian-chef install

rm -rf boxes/*/*.box
rm -rf "/home/jenkins-ci/VirtualBox VMs/boshlite-virtualbox-ubuntu1204"

cd boxes/
make vmware/boshlite-ubuntu1204.box
make virtualbox/boshlite-ubuntu1204.box
