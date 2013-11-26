# create cf release
set -e
set -x
PATH=/opt/rbenv/shims:/opt/rbenv/bin:$PATH
export TMPDIR=/mnt

ifconfig lo:1 192.168.50.4 netmask 255.255.255.0

mv /tmp/bosh-lite /mnt
cd /mnt/bosh-lite/
bosh -n target 127.0.0.1

wget -nv --tries=10 http://bosh-jenkins-gems-warden.s3.amazonaws.com/stemcells/latest-bosh-stemcell-warden.tgz -O latest-bosh-stemcell-warden.tgz
bosh -u admin -p admin -n upload stemcell latest-bosh-stemcell-warden.tgz

(
  cd cf-release
  git checkout deployed-to-prod
  last=` tail -1 releases/index.yml |grep -Po "\d+"`
  ref=${CF_VERSION:-"$last"}
  git checkout v${ref}
  cmd="bosh -u admin -p admin -n upload release releases/cf-${ref}.yml"
  $cmd || (sleep 120; bosh -u admin -p admin releases | grep cf ) || $cmd
)

wget -nv --tries=10 https://github.com/vito/spiff/releases/download/v0.2/spiff_linux_amd64 -O /usr/local/bin/spiff
chmod +x /usr/local/bin/spiff
CF_RELEASE_DIR=cf-release ./scripts/make_manifest_spiff

(
  cd cf-release
  cmd="bosh -u admin -p admin -n deploy"
  $cmd || $cmd
)

sleep 30
# wipe out all containers before exporting box. They will be lost anyway
/opt/warden/warden/root/linux/clear.sh /opt/warden/containers/
rm -rf /opt/warden/disks/ephemeral_mount_point/*
