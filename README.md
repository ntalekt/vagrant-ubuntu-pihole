# vagrant-ubuntu-pihole

A simple Vagrantfile to setup Ubuntu 18.04 server with Pi-hole on ESXi.

## Installs

* Pi-hole (latest release)
* NUT client (UPS monitoring)
* My public dotfiles
* VMware Tools
* Netplan config

## Usage

* Requires - <https://github.com/josenk/vagrant-vmware-esxi>

```bash
vagrant up
vagrant destroy -f
```
