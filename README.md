# Vagrant Base Box

## How to build

This box is built using [veewee](https://github.com/jedi4ever/veewee) (0.3.12) and the definitions in this repo. The definitions are based on stock veewee definitions for a minimal CentOS installation.

```sh
# Required only on the first build
$ veewee vbox define centos64x64 CentOS-6.4-x86_64-minimal

# Required on each subsequent build
$ veewee vbox build centos64x64
$ veewee vbox validate centos64x64
# Eject the disks from the running VM and shutdown.
$ vagrant package --base centos64x64 --output CentOS-6.4-x86_64-v20131107.box
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