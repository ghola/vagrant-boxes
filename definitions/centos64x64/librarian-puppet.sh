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

cd "$VEEWEE_DIR"

git clone https://github.com/ghola/vagrant-boxes.git

cp "vagrant-boxes/additions/Puppetfile" "$PUPPET_DIR"
echo "Copied Puppetfile"

gem install librarian-puppet
cd "$PUPPET_DIR" && librarian-puppet install --clean --verbose

cd "$CWD"
