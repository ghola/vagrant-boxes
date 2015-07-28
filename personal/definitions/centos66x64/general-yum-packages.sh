yum -y install gcc make gcc-c++ kernel-devel-`uname -r`
yum -y install zlib-devel openssl-devel readline-devel sqlite-devel perl wget dkms nfs-utils

yum -y install bzip2
yum -y install git
yum -y install erlang
yum -y install ImageMagick-devel
yum -y install geoip-devel
yum -y install librabbitmq-devel
yum -y install zip unzip p7zip p7zip-plugins
yum -y install ruby-devel
yum -y install augeas-devel
yum -y install augeas
yum -y install htop
yum -y install python-pip
alternatives --install /usr/bin/pip-python pip-python /usr/bin/pip 1
pip install meld3==1.0.1

