# bosh-lite

A lite development env for BOSH using Warden from within Vagrant.

This readme also includes demonstrates how to deploy Cloud Foundry into bosh-lite.

## Installation

For all use cases, first prepare this project with `bundler` & `librarian-chef`.

1. [Install vagrant](http://downloads.vagrantup.com/)

    Known to work for version:
    ```
    $ vagrant -v
    Vagrant 1.3.1
    ```
    Note: Vagrant 1.3.2+ using OSX and VirtualBox may encounter [this issue](https://github.com/mitchellh/vagrant/issues/2252) with Private Networking. The work-around is to downgrade to Vagrant 1.3.1 until Vagrant 1.3.4 is released.

1. Install Vagrant omnibus plugin
    ```
    vagrant plugin install vagrant-omnibus
    ```
1. Install Ruby + RubyGems + Bundler

1. Run Bundler from the base directory of this repository

    ```
    bundle
    ```

1. Run Librarian

    ```
    librarian-chef install
    ```

Below are installation processes for different Vagrant providers.

* VMWare Fusion
* Virtualbox
* AWS

### USE VMWare Fusion Provider

Known to work with Fusion version 5.0.3

1. Install vagrant Fusion Plugin + license

    ```
    vagrant plugin install vagrant-vmware-fusion
    vagrant plugin license vagrant-vmware-fusion license.lic
    ```


1. Start vagrant from the base directory of this repository (which uses the Vagrantfile)

    ```
    vagrant up --provider vmware_fusion
    ```

1. Bosh target (login with admin/admin)

    ```
    bosh target 192.168.50.4
    Target set to `Bosh Lite Director'
    Your username: admin
    Enter password: admin
    Logged in as `admin'
    ```

1. Add a set of route entries to your local route table to enable direct warden container access. Your sudo password may be required.

    ```
    scripts/add-route
    ```

###USE Virtualbox Provider


1. Start vagrant from the base directory of this repository (which uses the Vagrantfile)

    ```
    vagrant up
    ```

1. Bosh target (login with admin/admin)

    ```
    bosh target 192.168.50.4
    Target set to `Bosh Lite Director'
    Your username: admin
    Enter password: admin
    Logged in as `admin'
    ```

1. Add a set of route entries to your local route table to enable direct warden container access. Your sudo password may be required.

    ```
    scripts/add-route
    ```

###USE AWS Provider

1. Install Vagrant AWS provider

    ```
    vagrant plugin install vagrant-aws
    ```

1. Add dummy AWS box

    ```
    vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
    ```

1. Rename Vagrantfile.aws to Vagrantfile
1. Source your bosh_enviroment file

    ```
    source path/to/bosh_environment
    ```

1. Make sure the EC2 secure group you are using in the `Vagrantfile` exists and allows tcp/25555
1. Run Vagrant from the base directory of this repository (which uses the Vagrantfile):

    ```
    vagrant up --provider=aws
    ```
    
1. Bosh target (login with admin/admin)

    ```
    bosh target 192.168.50.4
    Target set to `Bosh Lite Director'
    Your username: admin
    Enter password: admin
    Logged in as `admin'
    ```    

## Troubleshooting

1. If you want to start over again, you can use `vagrant destory` from the base directory of this project to remove the VM.
1. To start with a new VM just execute the appropriate `vagrant up` command optionally with the provider option as shown in the earlier sections.

## Upload Warden stemcell

bosh-lite uses the Warden CPI, so we need to use the Warden Stemcell which will be the root file system for all Linux Containers created by the Warden CPI.

1. Download latest warden stemcell

    ```
    wget http://bosh-jenkins-gems-warden.s3.amazonaws.com/stemcells/latest-bosh-stemcell-warden.tgz
    ```

1. Upload Stemcell

    ```
    bosh upload stemcell latest-bosh-stemcell-warden.tgz
    ```

## Deploy Cloud Foundry

1. Generate CF deployment manifest

    ```
    cp manifests/cf-stub.yml manifests/[your-name-manifest].yml
    # replace director_uuid: PLACEHOLDER-DIRECTOR-UUID in [your-name-manifest].yml with the UUID from "bosh status"
    bosh deployment manifests/[your-name-manifest].yml
    bosh diff [cf-release]/templates/cf-aws-template.yml.erb
    ./scripts/transform.rb -f manifests/[your-name-manifest].yml
    ```

    or simply
    ```
    ./scripts/make_manifest
    ```

1. Create a CF release
1. Deploy!

## SSH into deployment jobs

To use `bosh ssh` to SSH into running jobs of a deployment, you need to specify various `bosh ssh` flags to use the Vagrant VM as the gateway.

To make it simple, add the following alias to your environment:

``` bash
alias ssh_boshlite='bosh ssh --gateway_host 192.168.50.4 --gateway_user vagrant --gateway_identity_file $HOME/.vagrant.d/insecure_private_key'
```

You can now SSH into any VM with `ssh_boshlite` in the same way you would run `bosh ssh`:

```
$ ssh_boshlite
1. nats/0
2. syslog_aggregator/0
3. postgres/0
4. uaa/0
5. login/0
6. cloud_controller/0
7. loggregator/0
8. loggregator-router/0
9. health_manager/0
10. dea_next/0
11. router/0
Choose an instance:
```
