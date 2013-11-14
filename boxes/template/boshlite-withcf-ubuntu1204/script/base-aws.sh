# Set up sudo - base careful to set the file attribue before copying to
# sudoers.d
( cat <<'EOP'
%packer ALL=NOPASSWD:ALL
EOP
) > /tmp/packer
chmod 0440 /tmp/packer
mv /tmp/packer /etc/sudoers.d/

#wait cloudinit to finish
while [ ! -f /var/lib/cloud/instance/boot-finished ] ; do sleep 1; done

apt-get -y update
#apt-get -y upgrade
#apt-get -y install curl
apt-get -y install make
apt-get clean
