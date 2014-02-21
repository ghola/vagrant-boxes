# Set the epel repo
cat > /etc/yum.repos.d/epel.repo << EOM
[epel]
name=Extra Packages for Enterprise Linux 6 - \$basearch
enabled=1
gpgcheck=1
mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=\$basearch
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
failovermethod=priority
priority=16
EOM

wget https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6 -O /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6


# Set the remi repo to exclude couchbase related packages so that they don't conflict with one from the couchbase repo
cat > /etc/yum.repos.d/remi.repo << EOM
[remi]
name=Les RPM de remi pour Enterpise Linux \$releasever - \$basearch
mirrorlist=http://rpms.famillecollet.com/enterprise/\$releasever/remi/mirror
enabled=1
gpgcheck=1
priority=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi
exclude=libcouchbase*
EOM

wget http://rpms.famillecollet.com/RPM-GPG-KEY-remi -O /etc/pki/rpm-gpg/RPM-GPG-KEY-remi

cat > /etc/yum.repos.d/remi-php55.repo << EOM
[remi-php55]
mirrorlist=http://rpms.famillecollet.com/enterprise/\$releasever/php55/mirror
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi
name=Les RPM de remi pour Enterpise Linux \$releasever - \$basearch - PHP 5.5
priority=1
EOM

cat > /etc/yum.repos.d/remi-test.repo << EOM
[remi-test]
name=Les RPM de remi pour Enterpise Linux \$releasever - \$basearch - Test
mirrorlist=http://rpms.famillecollet.com/enterprise/\$releasever/test/mirror
enabled=0
gpgcheck=1
priority=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi
EOM


# Set the rpm forge repo
rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm



yum -y update
yum -y install git
yum -y install erlang
yum -y install ImageMagick-devel
yum -y install geoip-devel
yum -y install librabbitmq-devel
yum -y install yum-utils
