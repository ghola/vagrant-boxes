puppet module install example42/yum

cat > repos.pp << EOM
class { 'yum':
    extrarepo => [ "epel", "remi", "remi_php55" ]
}
EOM

puppet apply repos.pp

yum -y update
yum -y install git
yum -y install erlang
yum -y install ImageMagick-devel
yum -y install geoip-devel
yum -y install librabbitmq-devel
yum -y install yum-utils
