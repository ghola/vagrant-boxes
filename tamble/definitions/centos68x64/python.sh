yum -y install https://centos6.iuscommunity.org/ius-release.rpm

yum -y install python27 python27-devel python27-pip python27-setuptools python27-virtualenv
yum -y erase ius-release

su - vagrant -c 'cd ~ && virtualenv-2.7 python-venv && cd python-venv && source bin/activate && pip2.7 install crossbar'
