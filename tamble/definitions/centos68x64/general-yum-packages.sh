yum -y install gcc make gcc-c++ kernel-devel-`uname -r`
yum -y install zlib-devel openssl-devel readline-devel sqlite-devel perl wget dkms nfs-utils

yum -y install bzip2 git erlang ImageMagick-devel geoip-devel librabbitmq-devel zip unzip p7zip p7zip-plugins
yum -y install ruby-devel augeas-devel augeas htop python-pip cifs-utils glibc-utils

alternatives --install /usr/bin/pip-python pip-python /usr/bin/pip 1
pip install meld3==1.0.1


