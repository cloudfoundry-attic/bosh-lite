name              "bosh-lite"
recipe            "bosh-lite::docker", "Adds docker repos and install docker packages"
recipe            "bosh-lite::warden", "Adds warden"
recipe            "bosh-lite::bosh", "Add bosh packages and gems"

%w{ ubuntu debian }.each do |os|
  supports os
end

depends 'apt'
depends 'git'
depends 'build-essential'
depends 'rbenv'
