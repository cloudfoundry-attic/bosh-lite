set -x

# Set up sudo - base careful to set the file attribute before copying to
# sudoers.d
( cat <<'EOP'
%packer ALL=NOPASSWD:ALL
EOP
) > /tmp/packer
chmod 0440 /tmp/packer
mv /tmp/packer /etc/sudoers.d/

apt-get -y update
apt-get clean

# libpq is required by the pg gem which is required by the postgresql chef recipe
# This is a workaround to avoid forking the postgresql cookbook
apt-get -y install libpq-dev
