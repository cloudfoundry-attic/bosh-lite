**This repository is deprecated**. It is no longer maintained, and it is not recommended for continued use. Vagrant BOSH lite has been deprecated in favor of [Virtualbox BOSH lite](https://github.com/cloudfoundry/bosh-deployment).

The original purpose of this project was to provide a pre-baked image where you could easily start BOSH with popular tools like Vagrant. Since then, we have made improvements to the provisioning process which avoids extra dependencies like `vagrant`, the original `bosh` Ruby CLI, and the original `bosh-init`.

Going forward, please follow the [recommended guide](http://bosh.io/docs/quick-start/) for running BOSH locally using VirtualBox. This improved process uses the same provisioning process as you would to deploy to any other IaaS; it ensures you are using recent BOSH components and features; and allows you to more easily change the configuration of BOSH for testing.
