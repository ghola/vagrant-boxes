source /usr/local/rvm/environments/ruby-2.1.5

# Run puppet to install all the other puppet managed services and configs
puppet apply --verbose --hiera_config /home/veewee/hiera.yaml --parser future --manifestdir /home/veewee /home/veewee/default.pp

# Stop couchbase if installed
if [ -f /etc/init.d/couchbase-server ]; then
    /etc/init.d/couchbase-server stop
    /sbin/chkconfig couchbase-server off
fi
