Veewee::Session.declare({
  :cpu_count => '1',
  :memory_size=> '1024',
  :disk_size => '10140',
  :disk_format => 'VDI',
  :hostiocache => 'off',
  :os_type_id => 'RedHat6_64',
  :iso_file => "CentOS-6.6-x86_64-minimal.iso",
  :iso_src => "http://yum.singlehop.com/CentOS/6.6/isos/x86_64/CentOS-6.6-x86_64-minimal.iso",
  :iso_md5 => "4a5fa01c81cc300f4729136e28ebe600",
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
      definition.box.scp('../additions/bundled-binaries/libreplication/libreplication.a', '/home/veewee/libreplication.a')
      definition.box.scp('../additions/bundled-binaries/libreplication/libreplication.so', '/home/veewee/libreplication.so')
      definition.box.scp('../additions/bundled-binaries/libreplication/libreplication.so.2', '/home/veewee/libreplication.so.2')
      definition.box.scp('../additions/bundled-binaries/libreplication/libreplication.so.0.2.0', '/home/veewee/libreplication.so.0.2.0')
      definition.box.scp('../additions/bundled-binaries/rpms/httpd-2.2.22-2.2.x86_64.rpm', '/home/veewee/httpd-2.2.22-2.2.x86_64.rpm')
      definition.box.scp('../additions/bundled-binaries/rpms/httpd-tools-2.2.22-2.2.x86_64.rpm', '/home/veewee/httpd-tools-2.2.22-2.2.x86_64.rpm')
      definition.box.scp('../additions/bundled-binaries/rpms/mod_ssl-2.2.22-2.2.x86_64.rpm', '/home/veewee/mod_ssl-2.2.22-2.2.x86_64.rpm')
      definition.box.scp('../additions/bundled-binaries/rpms/vsftpd-3.0.2-1.el6.x86_64.rpm', '/home/veewee/vsftpd-3.0.2-1.el6.x86_64.rpm')
      definition.box.scp('../additions/bundled-binaries/mysqlbinlog.so', '/home/veewee/mysqlbinlog.so')

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
    "puppet-setup.sh",
    "puppet-apply.sh",
    "keychain.sh",
    "pdf-tools.sh",
    "cleanup.sh",
    "zerodisk.sh"
  ],
  :postinstall_timeout => 10000
})
