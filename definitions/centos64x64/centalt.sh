# Install CentALT repo for apache only

cat > /etc/yum.repos.d/centalt.repo << EOM
[centalt]
name=CentALT RPM Repository
baseurl=http://centos.alt.ru/repository/centos/6/\$basearch/
enabled=1
gpgcheck=1
gpgkey=http://centos.alt.ru/repository/centos/RPM-GPG-KEY-CentALT
failovermethod=priority
priority=1
exclude=maria*
EOM