# Make sure Udev doesn't block our network
# http://6.ptmc.org/?p=164
echo "cleaning up udev rules"
rm /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces

# Clean up tmp
rm -rf /tmp/*

# Remove leftover leases
if [ -d "/var/lib/dhcp" ]; then
    echo "cleaning up dhcp leases"
    rm /var/lib/dhcp/*
fi

apt-get clean

echo "cleaning up chef"
dpkg -P chef
rm -rf /var/chef
rm -rf /opt/chef
rm -rf /etc/chef

echo "cleaning up logs"
find /var/log -type f | xargs rm -f
