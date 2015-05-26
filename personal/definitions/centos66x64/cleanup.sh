yum -y clean all
rm -rf VBoxGuestAdditions_*.iso
rm -rf /etc/puppet/.tmp
rm -rf /etc/puppet/.librarian
rm -rf /etc/puppet/Puppetfile.lock

# Remove traces of mac address from network configuration
sed -i /HWADDR/d /etc/sysconfig/network-scripts/ifcfg-eth0
rm /etc/udev/rules.d/70-persistent-net.rules
