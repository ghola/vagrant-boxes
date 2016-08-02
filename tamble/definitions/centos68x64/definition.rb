Veewee::Session.declare({
  :cpu_count => '1',
  :memory_size=> '1024',
  :disk_size => '10140',
  :disk_format => 'VDI',
  :hostiocache => 'off',
  :os_type_id => 'RedHat6_64',
  :iso_file => "CentOS-6.8-x86_64-minimal.iso",
  :iso_src => "http://centos.mirrors.linux.ro/6.8/isos/x86_64/CentOS-6.8-x86_64-minimal.iso",
  :iso_md5 => "0ca12fe5f28c2ceed4f4084b41ff8a0b",
  :iso_download_timeout => 1000,
  :boot_wait => "10",
  :boot_cmd_sequence => [
    '<Tab> text ks=http://%IP%:%PORT%/ks.cfg<Enter>'
  ],
  :kickstart_port => "7122",
  :kickstart_timeout => 10000,
  :kickstart_file => "ks.cfg",
  :ssh_login_timeout => "10000",
  :ssh_user => "veewee",
  :ssh_password => "veewee",
  :ssh_key => "",
  :ssh_host_port => "7222",
  :ssh_guest_port => "22",
  :sudo_cmd => "echo '%p'|sudo -S sh '%f'",
  :shutdown_cmd => "/sbin/halt -h -p",
  :hooks => {
    :before_postinstall => Proc.new {
      definition.box.scp('../additions/librarian-puppet-modules/Puppetfile', '/home/veewee/Puppetfile')
      definition.box.scp('../additions/bundled-binaries/rpms/httpd-2.2.22-2.2.x86_64.rpm', '/home/veewee/httpd-2.2.22-2.2.x86_64.rpm')
      definition.box.scp('../additions/bundled-binaries/rpms/httpd-tools-2.2.22-2.2.x86_64.rpm', '/home/veewee/httpd-tools-2.2.22-2.2.x86_64.rpm')
      definition.box.scp('../additions/bundled-binaries/rpms/mod_ssl-2.2.22-2.2.x86_64.rpm', '/home/veewee/mod_ssl-2.2.22-2.2.x86_64.rpm')
      definition.box.scp('../additions/bundled-binaries/rpms/vsftpd-3.0.2-1.el6.x86_64.rpm', '/home/veewee/vsftpd-3.0.2-1.el6.x86_64.rpm')
      definition.box.scp('../additions/bundled-binaries/rpms/rabbitmq-server-3.3.4-1.noarch.rpm', '/home/veewee/rabbitmq-server-3.3.4-1.noarch.rpm')
      definition.box.scp('../additions/bundled-binaries/rpms/wkhtmltox-0.12.2.1_linux-centos6-amd64.rpm', '/home/veewee/wkhtmltox-0.12.2.1_linux-centos6-amd64.rpm')
      definition.box.scp('../additions/bundled-binaries/rpms/keychain-2.7.0-1.el6.rf.noarch.rpm', '/home/veewee/keychain-2.7.0-1.el6.rf.noarch.rpm')

      definition.box.scp('additions/puppet/apply/hiera.yaml', '/home/veewee/hiera.yaml')
      definition.box.scp('additions/puppet/apply/hieradata/common.json', '/home/veewee/common.json')
      definition.box.scp('additions/puppet/apply/manifests/default.pp', '/home/veewee/default.pp')
    }
  },
  :postinstall_files => [
    "update-os.sh",
    "general-yum-packages.sh",
    "vagrant.sh",
    "virtualbox.sh",
    "install-additions.sh",
    "ruby.sh",
    "zeromq.sh",
    "js-tools.sh",
    "python.sh",
    "puppet-setup.sh",
    "puppet-apply.sh",
    "keychain.sh",
    "pdf-tools.sh",
    "zsh.sh",
    "cleanup.sh",
    "zerodisk.sh"
  ],
  :postinstall_timeout => 10000
})
