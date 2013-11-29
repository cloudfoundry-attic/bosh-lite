BOSH LITE SETUP AND INSTALLATION
================================

This step-by-step guide was created by Filip Hanik. In this guide there are three systems involved:

1. Your laptop or desktop environment (windows in my case)
1. A VM running BOSH and Cloud Foundry (Based on a vagrant template)
1. A VM hosting your git repositories (a new Ubuntu installation)

This guide has links to two pre-built VMs in case you do not want to have to deal with Vagrant at all. However, if you want to perform the setup yourself with all the steps, then simply follow along.

The First step is to create the VM containing Bosh Director that will also host Cloud Foundry.

    You can download the Bosh Director VM and skip to Section 1 below.                  
    VM: username: vagrant   password: vagrant
    See the step about adding the "route add" to make sure you have 
    192.168.50.4 IP address configured in the VM
    Link: https://drive.google.com/a/gopivotal.com/file/d/0B-6leBm8Y9DbNExsRUl4NlZXcGs/edit?usp=sharing

The following actions all take place on your desktop/laptop (host) environment:

- Install vagrant 1.3.5 (on windows this comes with ruby 1.9.3) and is installed from `Vagrant_1.3.5.msi`. After installation I can run `ruby -v` and it yields `ruby 1.9.3p448 (2013-06-27) [i386-mingw32]`
- Install the vmware workstation plugin from the command line `vagrant plugin install vagrant-vmware-workstation`
- Install the plugin license, note that fusion and workstation are different licenses`vagrant plugin license vagrant-vmware-workstation \path\to\.lic_file`
- make sure that your VMWare Fusion/Workstation has a 192.168.50.0 host only network. You can reach the network editor under `Edit -> Virtual Network Editor`. Mine is setup [like this](https://drive.google.com/file/d/0B-6leBm8Y9DbckNBbG1qY0lsVWs/edit?usp=sharing)
- clone the bosh-lite repository `git clone https://github.com/cloudfoundry/bosh-lite.git`
- Install the bundler gem: `gem install bundler`
- Update the bundles: 

```
cd bosh-lite
bundle update
```
  
- Copy your VagrantFile to the bosh-lite directory. An example of my file that allocates 12GB to the VM is [found here](https://drive.google.com/a/gopivotal.com/file/d/0B-6leBm8Y9DbWDVlS3B2cnlma0U/edit?usp=sharing)
- Create your Bosh Director VM from the command line in the bosh-lite directory: `vagrant up --provider vmware_workstation`
At this point I get a: `INFO interface: error: The HGFS kernel module was not found on the running virtual machine.`
I am ignoring it, as mounting HFFS  afew steps below seems to fix it.
- Login to the machine with vagrant/vagrant as the username/password
`vagrant ssh`
- Add the route required to handle all CF components:
`sudo route add -net 10.244.0.0/22 gw 192.168.50.4`
- Fix the HGFS error: 
     `sudo mount -t vmhgfs .host:/ /mnt/hgfs`
  
- Check the network. You should have three network adapters:

1. lo - your loopback on 127.0.0.1
1. eth0 - a NAT interface - Vagrant requires this
1. eth1 - your 192.168.50.4 IP that was configured in the Vagrantfile

Example:

```
     eth0      Link encap:Ethernet  HWaddr 00:0c:29:26:13:c6
                inet addr:192.168.43.137  Bcast:192.168.43.255  Mask:255.255.255.0
                inet6 addr: fe80::20c:29ff:fe26:13c6/64 Scope:Link
                UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
                RX packets:206 errors:0 dropped:0 overruns:0 frame:0
                TX packets:181 errors:0 dropped:0 overruns:0 carrier:0
                collisions:0 txqueuelen:1000
                RX bytes:24448 (24.4 KB)  TX bytes:20310 (20.3 KB)

      eth1      Link encap:Ethernet  HWaddr 00:0c:29:26:13:d0
                inet addr:192.168.50.4  Bcast:192.168.50.255  Mask:255.255.255.0
                inet6 addr: fe80::20c:29ff:fe26:13d0/64 Scope:Link
                UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
                RX packets:31 errors:0 dropped:0 overruns:0 frame:0
                TX packets:6 errors:0 dropped:0 overruns:0 carrier:0
                collisions:0 txqueuelen:1000
                RX bytes:3268 (3.2 KB)  TX bytes:468 (468.0 B)

      lo        Link encap:Local Loopback
                inet addr:127.0.0.1  Mask:255.0.0.0
                inet6 addr: ::1/128 Scope:Host
                UP LOOPBACK RUNNING  MTU:65536  Metric:1
                RX packets:1174 errors:0 dropped:0 overruns:0 frame:0
                TX packets:1174 errors:0 dropped:0 overruns:0 carrier:0
                collisions:0 txqueuelen:0
                RX bytes:295371 (295.3 KB)  TX bytes:295371 (295.3 KB)
```
     
- Restart the system
     `sudo reboot`

At this point our CF VM is ready to receive Bosh commands and packages.

BOSH LITE SETUP AND INSTALLATION
================================

The next step is to setup the 'Build and Release Box'

I started out with a clean ubuntu image from ubuntu-12.04.3-desktop-amd64.iso. Below are the steps for installing all the dependencies.
  You can skip all these steps and simply download the VM itself at:
  
```
If you download this you can skip to Section 4.
where you perform an actual deployment         
VM: username: fhanik   password:pivotal        
Link: https://drive.google.com/a/gopivotal.com/file/d/0B-6leBm8Y9DbWFNZcV9NcUZSUDQ/edit?usp=sharing
```

### Section 1 - Setup Basic Packages (start a terminal)

```
    sudo su - 
    echo 'fhanik ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
    
    apt-get -y clean
    apt-get -y update
    apt-get -y upgrade
    apt-get -y remove virtualbox-\*
    
    apt-get -y install git subversion build-essential git-core curl
    apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev
    apt-get -y install libxml2-dev libxslt-dev libreadline6-dev libyaml-dev
    apt-get -y install libncurses5-dev golang-go bzr libcurl3 libcurl3-gnutls libcurl4-openssl-dev
    apt-get -y install libmysqlclient-dev libpq-dev libsqlite3-dev 
```

### Section 2 - Get Ruby RVM and Ruby Gems Installed

    `exit` - this takes you to your user account. RVM will not work if installed as root.

```    
    bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
    echo '[[ -s "/home/fhanik/.rvm/scripts/rvm" ]] && source "/home/fhanik/.rvm/scripts/rvm"' >> ~/.bashrc
    source ~/.bashrc
    type rvm | head -1
    rvm install 1.9.3-p448
    rvm use --default 1.9.3-p448
    ruby -v
    gem install bundler 
    gem install gerrit-cli
    gem install rb-kqueue
```

### Section 3 - Configure the GIT repositories for cf-release and bosh-light

```
    git clone https://github.com/cloudfoundry/cf-release
    git clone https://github.com/cloudfoundry/bosh-lite.git
    git clone https://github.com/cloudfoundry/warden.git
    cd cf-release 
    git submodule update --init --recursive
    bundle update
    bosh -v 
    cd ~/bosh-lite/
    bundle update
    bosh -v 
    mkdir tmp
    export CF_RELEASE_DIR=~/cf-release
    echo "export CF_RELEASE_DIR=~/cf-release" >> ~/.bashrc
    cd ~
    git clone https://github.com/vito/spiff.git
    cd spiff
    sudo go get . 
    sudo ln -s ~/spiff/spiff /usr/local/bin/spiff
```

BOSH LITE SETUP AND INSTALLATION
================================

### Section 4 - Deploy CloudFoundry the bosh-lite way

```  
    cd ~/bosh-lite/
    bosh target 192.168.50.4 (use admin/admin as credentials)
    bosh upload stemcell http://bosh-jenkins-gems-warden.s3.amazonaws.com/stemcells/latest-bosh-stemcell-warden.tgz
    scripts/make_manifest_spiff

    cd ~/cf-release
    bosh create release
    #at this point I enter cf as the name of the release when asked
    bosh upload release
    bosh deployment ~/bosh-lite/manifests/cf-manifest.yml
    bosh deploy
```


