# Ensure puppet and wevee directories exist
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

CWD=$(pwd)

cd $VEEWEE_DIR

# Download the additions using git
git clone https://github.com/ghola/vagrant-boxes.git

# Install vsftpd to the latest version because the one from centos repo is 2.2.2
rpm -Uvh $VEEWEE_DIR/vagrant-boxes/additions/bundled-binaries/rpms/vsftpd-3.0.2-1.el6.x86_64.rpm

# Install httpd to a version above 2.2.18 in order to support AllowEncodedSlashes NoDecode
## First, install regular httpd for the dependencies users, groups, etc.
yum -y install httpd
## Then remove it (httpd-tools will also remove httpd)
yum -y remove httpd-tools
## And install the other version
rpm -Uvh $VEEWEE_DIR/vagrant-boxes/additions/bundled-binaries/rpms/httpd-tools-2.2.22-2.2.x86_64.rpm
rpm -Uvh $VEEWEE_DIR/vagrant-boxes/additions/bundled-binaries/rpms/httpd-2.2.22-2.2.x86_64.rpm
rpm -Uvh $VEEWEE_DIR/vagrant-boxes/additions/bundled-binaries/rpms/mod_ssl-2.2.22-2.2.x86_64.rpm

# Install keychain for automated ssh key loading
yum -y install keychain

# Install pip for python scripts
yum -y install python-pip

# Install RVM and update the ruby version
#\curl -sSL https://get.rvm.io | bash -s stable --ruby=1.9.3
#source /usr/local/rvm/scripts/rvm
#/usr/local/rvm/scripts/rvm 1> /dev/null
#rvm use 1.9.3 --default

# Disable docs for gems for faster installs
cat > /etc/gemrc << EOM
gem: --no-rdoc --no-ri
EOM

# Install keychain to load ssh keys
cat > /etc/profile.d/keychain.sh << EOM
### START-Keychain ###
# Let re-use ssh-agent and/or gpg-agent between logins
if [[ \$- == *i* ]]; then
    if [ -d "/vagrant/vagrant/dotfiles/.ssh" ]; then
        mkdir -p ~/.ssh
        /bin/cp -rf /vagrant/vagrant/dotfiles/.ssh/* ~/.ssh
        if [ -f ~/.ssh/id_dsa ]; then
            chmod 0600 ~/.ssh/id_*
        fi
    fi
    /usr/bin/keychain -q --ignore-missing ~/.ssh/id_dsa
    source ~/.keychain/\$HOSTNAME-sh
fi
### End-Keychain ###
EOM


# Needed for hiera deep_merge
gem install deep_merge

# Install librarian puppet and it's defined puppet modules
cp $VEEWEE_DIR/vagrant-boxes/additions/puppet/librarian-puppet-modules/Puppetfile $PUPPET_DIR
echo "Copied Puppetfile"

gem install librarian-puppet -v 1.0.3
cd "$PUPPET_DIR" && librarian-puppet install --clean --verbose

# Install libreplication
cp $VEEWEE_DIR/vagrant-boxes/additions/bundled-binaries/libreplication/* /usr/lib64/

# Run puppet to install all the other puppet managed services and configs
puppet apply --verbose --hiera_config $VEEWEE_DIR/vagrant-boxes/additions/puppet/apply/hiera.yaml --parser future --color=false --manifestdir $VEEWEE_DIR/vagrant-boxes/additions/puppet/apply/manifests --detailed-exitcodes $VEEWEE_DIR/vagrant-boxes/additions/puppet/apply/manifests/default.pp --evaluator current

cd $CWD
