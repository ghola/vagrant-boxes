source /usr/local/rvm/environments/ruby-2.1.5

gem install puppet -v 3.7.5
gem install ruby-augeas hiera hiera-puppet

# Needed for hiera deep_merge
gem install deep_merge

# Install librarian puppet and it's defined puppet modules
cp /home/veewee/Puppetfile /etc/puppet
echo "Copied Puppetfile"

gem install librarian-puppet
cd /etc/puppet && librarian-puppet install --clean --verbose
