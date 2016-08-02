sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

yum -y install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum -y install http://rpms.remirepo.net/enterprise/remi-release-6.rpm

rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt

yum -y install yum-utils yum-plugin-priorities
yum-config-manager --enable epel
yum-config-manager --enable remi
yum-config-manager --enable remi-php55
yum-config-manager --enable extras

yum -y update

# Make ssh faster by not waiting on DNS
echo "UseDNS no" >> /etc/ssh/sshd_config
