PUPPET_DIR=/etc/puppet/
VEEWEE_DIR=/home/veewee/

# Ensure puppet and veewee directories exist
PUPPET_DIR=/etc/puppet/
VEEWEE_DIR=/home/veewee/

if [[ ! -d "$PUPPET_DIR" ]]; then
    mkdir -p "$PUPPET_DIR"
    echo "Created directory $PUPPET_DIR"
fi

if [[ ! -d "$VEEWEE_DIR" ]]; then
    mkdir -p "$VEEWEE_DIR"
    echo "Created directory $VEEWEE_DIR"
fi

cd $VEEWEE_DIR

# Install vsftpd to the latest version because the one from centos 6 repo is 2.2.2
rpm -Uvh $VEEWEE_DIR/vsftpd-3.0.2-1.el6.x86_64.rpm

# Install httpd to a version greater than 2.2.18 in order to support AllowEncodedSlashes NoDecode
## First, install regular httpd for the dependencies users, groups, etc.
yum -y install httpd
## Then remove it (httpd-tools will also remove httpd)
yum -y remove httpd-tools
## And install the other version
rpm -Uvh $VEEWEE_DIR/httpd-tools-2.2.22-2.2.x86_64.rpm
rpm -Uvh $VEEWEE_DIR/httpd-2.2.22-2.2.x86_64.rpm
rpm -Uvh $VEEWEE_DIR/mod_ssl-2.2.22-2.2.x86_64.rpm

# Install libreplication
cp $VEEWEE_DIR/libreplication.* /usr/lib64/

cd $CWD
