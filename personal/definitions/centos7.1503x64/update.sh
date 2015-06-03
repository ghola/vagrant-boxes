http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
wget http://rpms.remirepo.net/enterprise/remi-release-7.rpm
rpm -Uvh remi-release-7*.rpm epel-release-7*.rpm

yum -y install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm

yum -y install yum-utils
yum-config-manager --enable epel
yum-config-manager --enable remi
yum-config-manager --enable remi-php55


yum -y update
yum -y install bzip2
yum -y install git
yum -y install erlang
yum -y install ImageMagick-devel
yum -y install geoip-devel
yum -y install librabbitmq-devel
yum -y install zip
yum -y install unzip
yum -y install ruby-devel
