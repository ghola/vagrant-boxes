##### Ntp #####

class { '::ntp': }

##### Git #####

if $gitconf == undef {
    $gitconf = hiera_hash('git',{})
}

if count($gitconf) > 0 and $gitconf['config']  {
    create_resources(git::config, $gitconf['config'])
}

if count($gitconf) > 0 and $gitconf['system-config']  {
    create_resources(tamblegit::system_config, $gitconf['system-config'])
}


##### Yum #####

if $yumconf == undef {
    $yumconf = hiera_hash('yum',{})
}
if count($yumconf) > 0 {
    class { 'yum':
        extrarepo => $yumconf['repos']
    }
}

##### Resolver #####

if $resolverconf == undef {
    $resolverconf = hiera_hash('resolver',{})
}

class { 'resolver' :
    dns_servers => $resolverconf['dns_servers'],
    search      => $resolverconf['search']
}


##### Apache #####

if $apacheconf == undef {
    $apacheconf = hiera_hash('apache',{})
}

class { 'apache':
    default_vhost => $apacheconf['default_vhost'],
    mpm_module    => $apacheconf['mpm_module'],
}

if $apacheconf['vhosts'] {
    create_resources(apache::vhost, $apacheconf['vhosts'])
}

define apache_mod {
    if ! defined(Class["apache::mod::${name}"]) {
        class { "apache::mod::${name}": }
    }
}

if $apacheconf['modules'] and count($apacheconf['modules']) > 0 {
    apache_mod { $apacheconf['modules']:
        require => Class['php']
    }
}

# makes sure apache uses the correct umask
exec { 'apache umask':
    command => '/bin/echo "umask 002" >> /etc/sysconfig/httpd',
    unless  => '/bin/grep -Fx "umask 002" /etc/sysconfig/httpd',
    require => Class['apache'],
    notify  => Service['httpd']
}

User<| title == apache |> { groups +> [ "wheel" ] }


##### Firewall #####

if $firewallconf == undef {
    $firewallconf = hiera_hash('iptables',{})
}

create_resources(iptables::rule, $firewallconf)


##### PHP #####

if $phpconf == undef {
    $phpconf = hiera_hash('php',{})
}

Class['Php'] -> Class['Php::Devel'] -> Tamblephp::Ini <| |> -> Php::Module <| |> -> Php::Pear::Module <| |> -> Php::Pecl::Module <| |>

class { 'php':
    version => $phpconf['version']
}

class { 'php::devel': }

if $phpconf['modules']['php'] and is_hash($phpconf['modules']['php']) {
    create_resources(php::module, $phpconf['modules']['php'])
}

if $phpconf['modules']['pear'] and is_hash($phpconf['modules']['pear']) {
    create_resources(php::pear::module, $phpconf['modules']['pear'])
}

if $phpconf['modules']['pecl'] and is_hash($phpconf['modules']['pecl']) {
    create_resources(php::pecl::module, $phpconf['modules']['pecl'])

    $phpconf['modules']['pecl'].each |$key, $value| {

        if $key != 'xdebug' and $key != 'couchbase' and $key != 'pecl-memcached' and $key != 'memcached' {
            tamblephp::ini { "${key}-extension":
                entry        => ".anon/extension",
                value        => "${key}.so",
                ini_filename => "${key}.ini",
                require      => Class["php"]
            }
        }

        # couchbase extension MUST laod after the json one, so i've put them in the same ini
        if $key == 'couchbase' {
            tamblephp::ini { "${key}-extension":
                entry        => ".anon/extension[2]",
                value        => "${key}.so",
                ini_filename => "json.ini",
                require      => Class["php"]
            }
        }

        # memcached extension MUST laod after the json one, so i've put them in the same ini
        if $key == 'memcached' {
            tamblephp::ini { "${key}-extension":
                entry        => ".anon/extension[3]",
                value        => "${key}.so",
                ini_filename => "json.ini",
                require      => Class["php"]
            }
        }
    }
}

if $phpconf['modules']['file'] and is_hash($phpconf['modules']['file']) {
    create_resources(tamblephp::file::module, $phpconf['modules']['file'])
}

if $phpconf['composer'] == true {
    class { 'composer': }
}

if $phpconf['ini'] and count($phpconf['ini']) > 0 {
    $phpconf['ini'].each |$key, $value| {
        tamblephp::ini { $key:
            entry       => "TAMBLE/${key}",
            value       => $value
        }
    }
}

if $phpconf['modules']['pecl']['xdebug'] and is_hash($phpconf['modules']['pecl']['xdebug']) {
    tamblephp::ini { 'xdebug-extension':
        entry => ".anon/zend_extension",
        value  => "xdebug.so",
        ini_filename => "xdebug.ini",
        require => Class["php"]
    }
}

##### MySQL #####

if $mysqlconf == undef {
    $mysqlconf = hiera_hash('mysql',{})
}

class { 'mysql::server':
    root_password    => $mysqlconf['root_password'],
    override_options => $mysqlconf['override_options']
}

if $mysqlconf['databases'] {
    create_resources('mysql::db', $mysqlconf['databases'])
}

if $mysqlconf['users'] {
    $mysqlconf['users'].each |$key, $value| {
        mysql_user { "${value['user']}@${value['host']}" :
            password_hash => $value['password_hash'],
            require       => Class['mysql::server'],
        }
    }
}

if $mysqlconf['grants'] {
    $mysqlconf['grants'].each |$key, $value| {
        mysql_grant { "${value['user']}@${value['host']}/${value['table']}" :
            privileges => $value['privileges'],
            options    => $value['options'],
            provider   => 'mysql',
            user       => "${value['user']}@${value['host']}",
            table      => $value['table'],
            require    => Class['mysql::server'],
        }
    }
}

# Load the timezone tables
#exec { 'mysql timezones':
#    command    => '/usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo | /usr/bin/mysql -u root mysql',
#    require    => Class['mysql::server'],
#}

##### phpMyAdmin #####

if $pmaconf == undef {
    $pmaconf = hiera_hash('phpmyadmin',{})
}

class { 'phpmyadmin':
    enabled          => 'true',
    ip_access_ranges => $pmaconf['ip_access_ranges'],
    require          => Class['mysql::server']
}

phpmyadmin::server{ 'default': }


##### Couchbase #####

if $couchconf == undef {
    $couchconf = hiera_hash('couchbase',{})
}

if count($couchconf) > 0 {
    class { 'couchbase':
        size     => $couchconf['size'],
        user     => $couchconf['user'],
        password => $couchconf['password'],
        version  => $couchconf['version'],
        edition  => $couchconf['edition'],
    }

    if $couchconf['buckets'] {
        create_resources(couchbase::bucket, $couchconf['buckets'])
    }

    if $couchconf['clientlibs'] {
        create_resources(couchbase::client, $couchconf['clientlibs'])
    }

    Class['Couchbase'] -> Couchbase::Client <| |> -> Php::Pecl::Module['couchbase']
}

##### Memcached #####

if $memconf == undef {
    $memconf = hiera_hash('memcached',{})
}

if count($memconf) > 0 {
    class { 'memcached':
        cachesize => $memconf['cachesize'],
        port      => $memconf['port'],
        maxconn   => $memconf['maxconn'],
        options   => $memconf['options'],
    }
}

##### RabbitMQ #####

if $rabbitconf == undef {
    $rabbitconf = hiera_hash('rabbitmq',{})
}
    
if count($rabbitconf) > 0 {
    class { 'rabbitmq':
        admin_enable     => true,
        node_ip_address  => $rabbitconf['node_ip_address'],
        version          => $rabbitconf['version'],
        package_source   => $rabbitconf['package_source'],
        package_provider => $rabbitconf['package_provider'],
        config_variables => $rabbitconf['config_variables']
    }

    if $rabbitconf['plugins'] {
        tamblerabbitmq::plugins { 'blah':
            plugins => $rabbitconf['plugins'],
            require => Service['rabbitmq-server']
        }
    }

    if $rabbitconf['vhosts'] {
        tamblerabbitmq::vhosts { 'blah':
            vhosts => $rabbitconf['vhosts'],
            require => Service['rabbitmq-server']
        }
    }

    if $rabbitconf['users'] {
        tamblerabbitmq::users { 'blah':
            users => $rabbitconf['users'],
            require => Service['rabbitmq-server']
        }
    }

    if $rabbitconf['user_permissions'] {
        tamblerabbitmq::user_permissions { 'blah':
            user_permissions => $rabbitconf['user_permissions'],
            require => Service['rabbitmq-server']
        }
    }
}

##### Rubygems #####

if $gemsconf == undef {
    $gemsconf = hiera_array('rubygems',[])
}

if count($gemsconf) > 0 {
    package { $gemsconf:
        ensure => 'installed',
        provider => 'gem',
    }
}

##### ENV #####

if $envconf == undef {
    $envconf = hiera_hash('env',{})
}

create_resources(env::variable, $envconf)


##### Users #####

if $usersconf == undef {
    $usersconf = hiera_hash('users',{})
}

create_resources(user, $usersconf)

# ensure home directories are created with proper rights and group
# and that the bash skel files are copied
if count($usersconf) > 0 {
    $usersconf.each |$username, $params| {
        if $params['home'] {
            if ! defined(File[$params['home']]) {
                exec { "/bin/mkdir -p ${params['home']}":
                    creates => "${params['home']}"
                }
                file { $params['home']:
                    ensure  => 'directory',
                    mode    => '2775',
                    group   => 'wheel',
                    require => Exec["/bin/mkdir -p ${params['home']}"]
                }
            } else {
                File<| title == $params['home'] |> {
                    group  => 'wheel',
                    mode   => '2775',
                }
            }

            $files = ['.bashrc','.bash_profile','.bash_logout']

            $files.each |$key, $file| {
                file { "${params['home']}/${file}":
                    ensure  => 'present',
                    source  => "/etc/skel/${file}",
                    group   => $username,
                    owner   => $username,
                    mode    => 0644,
                    require => File[$params['home']]
                }
            }
        }
    }
}


##### VSFTPD #####

class{ 'vsftpd': }


##### NFS #####

if $nfsconf == undef {
    $nfsconf = hiera_hash('nfs',{})
}

if count($nfsconf) > 0 {
	create_resources(tamblenfs::mount, $nfsconf)
}

##### Supervisord #####

class{ 'supervisord':
    umask                => '002',
    inet_server          => true,
    inet_server_hostname => '*',
    executable           => '/usr/bin/supervisord',
    executable_ctl       => '/usr/bin/supervisordctl'
}

##### Cron jobs #####

if $cronconf == undef {
    $cronconf = hiera_hash('cronjobs',{})
}

if count($cronconf) > 0 {
	create_resources(cron::job, $cronconf)
}

##### Custom execs #####

if $execconf == undef {
    $execconf = hiera_hash('execs',{})
}

if count($execconf) > 0 {
	create_resources(exec, $execconf)
}

############ Helper types ############

# Helps define a php extension using a filesystem file

define tamblephp::file::module($source) {
    $filename = regsubst($source, '^[ ]*/?([^/]+/)*([^/]+)[ ]*$', '\2')
    $extension = regsubst($filename, '^([^\.]+).*$', '\1')

    file { "/usr/lib64/php/modules/$filename":
        source  => $source,
        require => Class['php'],
        notify  => Service['httpd']
    }

    tamblephp::ini { 'extension':
        entry => ".anon/extension",
        value  => "$filename",
        ini_filename => "$extension.ini",
        require => File["/usr/lib64/php/modules/$filename"]
    }
}


# Helps define a ini entry in an ini file

define tamblephp::ini (
    $ini_filename = 'tamble_custom.ini',
    $entry,
    $value  = '',
    $ensure = present
) {

    $target_dir  = '/etc/php.d'
    $target_file = "${target_dir}/${ini_filename}"

    if ! defined(File[$target_file]) {
        file { $target_file:
          replace => no,
          ensure  => present,
          require => Class['php'],
          notify  => Service['httpd']
        }
    }

    php::augeas { "${entry}-${value}" :
        target  => $target_file,
        entry   => $entry,
        value   => $value,
        ensure  => $ensure,
        require => File[$target_file],
        notify  => Service['httpd'],
    }

}


# Simple type to mount nfs

define tamblenfs::mount (
    $mountpoint = $title,
    $ensure = 'mounted',
    $atboot,
    $remounts,
    $device,
    $fstype = 'nfs',
    $options = 'defaults'
){
    package { 'nfs_package':
        ensure => installed,
        name   => 'nfs-utils',
    }

    if ! defined(File[$mountpoint]) {
        exec { "/bin/mkdir -p ${mountpoint}":
            creates => "${params['home']}"
        }
        file { $mountpoint:
            ensure  => 'directory',
            mode    => '2775',
            group   => 'wheel',
            require => Exec["/bin/mkdir -p ${mountpoint}"]
        }
    } else {
        File<| title == $mountpoint |> {
            group  => "wheel",
            mode   => '2775',
        }
    }

    mount { $mountpoint:
        ensure   => $ensure,
        atboot   => $atboot,
        remounts => $remounts,
        device   => $device,
        fstype   => $fstype,
        options  => $options,
        require  => File[$mountpoint]
    }
}


# Rabbitmq helpers to bypass puppet module bug of not starting the service before running rabbitmqctl

define tamblerabbitmq::plugins (
    $plugins
){
    create_resources(rabbitmq_plugin, $plugins)
}

define tamblerabbitmq::vhosts (
    $vhosts
){
    create_resources(rabbitmq_vhost, $vhosts)
}

define tamblerabbitmq::users (
    $users
){
    create_resources(rabbitmq_user, $users)
}

define tamblerabbitmq::user_permissions (
    $user_permissions
){
    create_resources(rabbitmq_user_permissions, $user_permissions)
}

# Helper to define git system configs

define tamblegit::system_config(
    $value,
    $section  = regsubst($name, '^([^\.]+)\.([^\.]+)$','\1'),
    $key      = regsubst($name, '^([^\.]+)\.([^\.]+)$','\2'),
) {
    exec{ "git config --system ${section}.${key} '${value}'":
        environment => inline_template('<%= "HOME=" + ENV["HOME"] %>'),
        path        => ['/usr/bin', '/bin'],
        unless      => "git config --system --get ${section}.${key} '${value}'",
    }
}

