Templates and scripts are based on https://github.com/misheska/basebox-packer

##How to build the boxes

A GNU Make makefile is provided to support automated builds.  It assumes
that both GNU Make and Packer are in the PATH.  Download and install
Packer from <http://www.packer.io/downloads.html>

To build a box:

    make list
    # Choose a definition, like 'virtualbox/boshlite-ubuntu1204'
    make virtualbox/boshlite-ubuntu1204
