apt-get -y install libsqlite3-dev  libmysqlclient-dev
[ -f ~/.ssh/id_rsa ] || ssh-keygen -f  ~/.ssh/id_rsa -N "" -q
touch ~/.ssh/known_hosts

export TMPDIR=/mnt
cd /mnt
git clone https://github.com/cloudfoundry/bosh.git
cd bosh
git checkout origin/warden-cpi -b warden-cpi
bundle
wget -nv -N http://bosh-jenkins-gems-warden.s3.amazonaws.com/stemcells/latest-bosh-stemcell-warden.tgz
bundle exec bosh -n target 192.168.50.4:25555

# a pre upload so we stopped early when director dies etc.
bundle exec bosh -u admin -p admin -n upload stemcell ./latest-bosh-stemcell-warden.tgz || sleep 30
DIRECTOR_UUID=$(bosh -u admin -p admin status | grep UUID | awk '{print $2}')
echo $DIRECTOR_UUID

# Create bat.spec
cat > bat.spec << EOF
---
cpi: warden
properties:
  static_ip: 10.244.0.2
  uuid: $DIRECTOR_UUID
  pool_size: 1
  stemcell:
    name: bosh-stemcell
    version: latest
  instances: 1
  mbus: nats://nats:0b450ada9f830085e2cdeff6@10.42.49.80:4222
EOF

export BAT_DEPLOYMENT_SPEC=$(pwd)/bat.spec
export BAT_DIRECTOR=192.168.50.4
export BAT_DNS_HOST=192.168.50.4
export BAT_STEMCELL=$(pwd)/latest-bosh-stemcell-warden.tgz
export BAT_VCAP_PASSWORD=c1oudc0w
cd bat
bundle exec rake bat



