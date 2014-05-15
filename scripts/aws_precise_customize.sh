apt-get update
apt-get -qq -y install make

# Add user vagrant
grep -q vagrant /etc/passwd || useradd vagrant

ifconfig lo:1 192.168.100.4 netmask 255.255.255.0

[ -d  /mnt/chef ]  || cp -a /opt/chef /mnt/chef
mount --bind /mnt /opt
