yum -y install make automake gcc gcc-c++ kernel-devel wget tar fuse fuse-devel

wget -O /usr/local/src/bindfs-1.13.7.tar.gz http://bindfs.org/downloads/bindfs-1.13.7.tar.gz
cd /usr/local/src && tar -xzf bindfs-1.13.7.tar.gz
cd /usr/local/src/bindfs-1.13.7 && /usr/local/src/bindfs-1.13.7/configure && /usr/bin/make && /usr/bin/make install

touch /etc/fuse.conf
/sbin/modprobe fuse
