set -x
set -e 

PATH=/usr/local/packer/:/home/jenkins/.rbenv/bin:/home/jenkins/.rbenv/shims:/home/jenkins/.rbenv/bin:$PATH

bundle
bundle exec librarian-chef install

rm -rf boxes/*/*.box
rm -rf "/home/jenkins/VirtualBox VMs/boshlite-virtualbox-ubuntu1204"

cd boxes/
make vmware/boshlite-ubuntu1204.box
make virtualbox/boshlite-ubuntu1204.box
