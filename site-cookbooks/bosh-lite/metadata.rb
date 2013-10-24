name              "bosh-lite"
version           "0.1"
recipe            "bosh-lite::rbenv", "Setup rbenv, ruby and bundler"
recipe            "bosh-lite::warden", "Setup warden"
recipe            "bosh-lite::bosh", "Setup bosh packages and gems"

%w{ ubuntu debian }.each do |os|
  supports os
end

depends 'apt'
depends 'git'
depends 'build-essential'
depends 'rbenv'
depends 'openssl'
depends 'postgresql'
depends 'database'
