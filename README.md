# Vagrant Base Box

## How to build

There are two main directories: personal and tamble. To build boxes you need to 'cd' into one of them. Example

```sh
# Required only if you want to define a new vbox following a template
# The alternative is to just copy an existing definition directory and make changes to it
$ veewee vbox define centos68x64 CentOS-6.8-x86_64-minimal

# Required on each subsequent build
$ veewee vbox build centos68x64
$ veewee vbox validate centos68x64
# Eject the disks from the running VM and shutdown.
$ vagrant package --base centos68x64 --output CentOS-6.8-x86_64-v20150526.box
```

## Contents

- `libreplication` - binaries of https://github.com/BullSoft/mysql-replication-listener compiled against PHP 5.5.6 and MySQL 5.5.34
- `binlog.so` - php extension https://github.com/BullSoft/php-binlog compiled against PHP 5.5.6 and MySQL 5.5.34
- `Puppetfile` - config file for librarian puppet

These files are bundled with the machine by cloning this very repository.

## Deviations from stock definitions

- Removed Chef.
- Added some ruby gems packages (rubygems.sh).
- Packages update from newer repos via puppet, and install of additional packages (update.sh)
-- git
-- erlang
- Librarian puppet installation (librarian-puppet.sh). The goal is to install some puppet modules directly from their repositories and not from the forge due to bugs found in forge modules.
- Added libreplication library (libreplication.sh).
