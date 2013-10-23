set -x
set -e 

PATH=/usr/local/packer/:/home/jenkins-ci/.rbenv/bin:/home/jenkins-ci/.rbenv/shims:/home/jenkins-ci/.rbenv/bin:$PATH

bundle
bundle exec librarian-chef install

rm -rf boxes/*/*.box

cd boxes/
make virtualbox/boshlite-withcf-ubuntu1204.box
make vmware/boshlite-withcf-ubuntu1204.box
