# Vagrant Base Boxes

## How these boxes were built

These boxes were automatically built using [veewee](https://github.com/jedi4ever/veewee) (0.3.12) and the definitions in this repo. The definitions are stock veewee definitions for a minimal CentOS installation, but modified so Chef is not installed.

```sh
$ veewee vbox define centos64x64 CentOS-6.4-x86_64-minimal
$ veewee vbox build centos64x64
$ veewee vbox validate centos64x64
# Eject the disks from the running VM and shutdown.
$ vagrant package --base centos64x64 --output CentOS-6.4-x86_64-v20131107.box
```