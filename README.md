#bosh-lite

A lite development env for BOSH using Docker.io from within vagrant

**Warning:**   This is very much a work in progress and not really suited for use.... really run and hide.

###Instalation

1. Install Fusion 

1. Install vagrant
           http://downloads.vagrantup.com/

1. Install vagrant Fusion Plugin + license (optional)
       
    $> vagrant plugin install vagrant-vmware-fusion
    $> vagrant plugin license vagrant-vmware-fusion license.lic

1. Install Ruby + RubyGems + Bundler
1. Run Bundler
     
    $> bundle

1. Run Librarian

    $> librarian-chef install

1. Start vagrant

    $> vagrant up # --prover vmware_fusion (optional)

1. Restart vagrant after chef provision

    $> vagrant reload

1. Bosh target

    $> bosh target 192.168.50.4
