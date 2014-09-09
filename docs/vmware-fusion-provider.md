## Using the VMware Fusion Provider

1. Install licensed VMware Fusion

    Known working version:

    ```
    $ vmware-vmx -v
    VMware Fusion Information:
    VMware Fusion 6.0.4 build-1887983 Release
    ```

1. Install licensed `vagrant-vmware-fusion` plugin

    Known working version:

    ```
    $ vagrant plugin list | grep vmware-fusion
    vagrant-vmware-fusion (2.5.2)
    ```

1. Start Vagrant from the base directory of this repository. This uses the Vagrantfile.

    ```
    vagrant up --provider=vmware_fusion
    ```

1. Target the BOSH Director and login with admin/admin.

    ```
    $ bosh target 192.168.50.4 lite
    Target set to `Bosh Lite Director'

    $ bosh login
    Your username: admin
    Enter password: *****
    Logged in as `admin'
    ```

1. Add a set of route entries to your local route table to enable direct Warden container access every time your networking gets reset (e.g. reboot or connect to a different network). Your sudo password may be required.

    ```
    bin/add-route
    ```
