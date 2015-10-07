## How to build the Vagrant boxes

First, download and install Packer from <http://www.packer.io/docs/installation.html>.

Binaries for creating VirtualBox, VMWare Fusion, and Amazon EC2 boxes are provided in `bin/`.

Binary                  | Host Environment
----------------------- | ----------------
packer/build-virtualbox | VirtualBox
packer/build-vmware     | VMWare Fusion
packer/build-aws        | Amazon EC2

Each binary takes a required set of arguments:

Argument               | Purpose
---------------------- | -------
bosh_release_version   | the BOSH release manifest version for the bosh release
warden_release_version | the BOSH release manifest version for the bosh-warden-cpi release
garden_release_version | the BOSH release manifest version for the garden-linux release

Example: `packer/build-vbox 206 27 0.306.0`

Each binary also takes an optional build number, to be included in the output filename, defaults to 0.

See `ci/build-box-local.sh` and `ci/build-box-aws.sh` for an example how these scripts are used in CI.

### Amazon EC2 Only

`build-aws` requires `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables to be set

Additionally, `packer/build-aws` takes optional arguments for base_ami (e.g. ami-864d84ee) and region (e.g. us-east-1) which are to be passed after the required arguments.

The default AMI, ami-d2ff23ba (us-east-1) is a public Ubuntu Trusty amd64 ebs AMI, found at http://cloud-images.ubuntu.com/locator/ec2/.

Please see usage for each binary for more details by running any of the binaries without any arguments.
