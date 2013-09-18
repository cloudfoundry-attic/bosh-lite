# Set up sudo - base careful to set the file attribue before copying to
# sudoers.d
( cat <<'EOP'
%packer ALL=NOPASSWD:ALL
EOP
) > /tmp/packer
chmod 0440 /tmp/packer
mv /tmp/packer /etc/sudoers.d/

apt-get -y update
#apt-get -y upgrade
#apt-get -y install curl
apt-get clean
