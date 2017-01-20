class { "vmbuildhelper": }
class { "vmbuildhelper::ntp": }
class { "vmbuildhelper::git": }
class { "vmbuildhelper::yum": }
class { "vmbuildhelper::apache": }
class { "vmbuildhelper::firewall": }
class { "vmbuildhelper::php": }
class { "vmbuildhelper::mysql": }
class { "vmbuildhelper::phpmyadmin": }
class { "vmbuildhelper::memcached": }
class { "vmbuildhelper::env": }
class { "vmbuildhelper::users": }
class { "vmbuildhelper::vsftpd": }
class { "vmbuildhelper::nfs": }
class { "vmbuildhelper::supervisord": }
class { "vmbuildhelper::cron": }
class { "vmbuildhelper::execs": }

class { "::apache::mod::php":
  package_name => 'php',
  php_version  => '7.1',
  path         => 'modules/libphp7.so',
  require      => Class['php']
}
