Templates and scripts are based on <https://github.com/misheska/basebox-packer>

##Build the Vagrant boxes

1. Install Ruby + RubyGems + Bundler

1. Run Bundler from the base directory of this repository

    ```
    bundle
    ```

1. Run Librarian

    ```
    librarian-chef install
    ```

1. Download and install Packer from <http://www.packer.io/docs/installation.html>


1. Build the boxes

 A GNU Make makefile is provided to support automated builds.  It assumes that GNU Make is in the PATH.

 To build all boxes:

        cd boxes
        make

 Or, to build one box:

        cd boxes
        make list
        # Choose a definition, like 'virtualbox/boshlite-ubuntu1204.box'
        make virtualbox/boshlite-ubuntu1204.box


