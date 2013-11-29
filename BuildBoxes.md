Templates and scripts are based on https://github.com/misheska/basebox-packer

##Build the boxes

A GNU Make makefile is provided to support automated builds.  It assumes
that both GNU Make and Packer are in the PATH.  Download and install
Packer from <http://www.packer.io/docs/installation.html>


To build all boxes:

    cd boxes
    make

Or, to build one box:

    cd boxes
    make list

    # Choose a definition, like 'virtualbox/boshlite-ubuntu1204.box'
    make virtualbox/boshlite-ubuntu1204.box
