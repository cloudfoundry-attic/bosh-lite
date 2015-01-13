#!/bin/bash

source $(dirname $0)/ci_helpers.sh

main() {
  chruby 2.1.2
  sudo apt-get update

  install_bundle

  install_vagrant_prerequisites
  install_s3cmd
  install_jq
  install_aws_cli

  #required for bats
  set_virtualbox_machine_folder
}

main
