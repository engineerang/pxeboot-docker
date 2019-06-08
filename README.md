# pxeboot-docker
pxeboot-docker brings together spriteful and pixiecore to make pxebooting easy!


## TL;DR
Boot another machine from the same network.

Clone the project:
```shell
git clone https://github.com/engineerang/pxeboot-docker.git
cd pxeboot-docker
```
Change "mac": "00:00:00:00:00:00" or  "mac": "11:11:11:11:11:11" to a machine's mac address you'd like to boot:
```shell
vim config.json.example
```
Run docker-compose:
```shell
docker-compose up
```

## Why?
pxeboot-docker is a docker project aimed at making pxebooting trivial. To do this it brings together pixiecore and spriteful to create a minimalist pxebooting service. 

As elegantly covered by [pixiecore](https://github.com/danderson/netboot/tree/master/pixiecore), PXEBooting shouldn't be as hard as it is to setup. And although pixiecore has achieved reducing the complexity, it stops at providing a mechanism to control what configuration a certain machine on your network should boot with, this is where spriteuful comes in. [spriteful](https://github.com/engineerang/spriteful) is an API that provides server boot configurations for pixiecore. 

# Installation

## Requirements
In order to use this project you will need a few things:
### Docker
Docker is required, see the installation guide for your flavour of operating system.

This has been mostly tested with Docker on Linux (Ubuntu) and i can't make any guarantees that it will work from MacOS or Windows. 
### Docker-compose
The easiest way to get docker-compose is through Python's package manager, pip.

```
python36 -m venv .env
source .env/bin/activate
pip install docker-compose
```

## Running

### config.json
The configuration of machines is done via the config.json. The provided [sample](config.json.example) configuration demonstrates how it can be rudimentarily used for CoreOS or Centos 7 (not at all production ready). 

The config.json structure follows the basic concepts of the pxelinux.cfg file, for example:

```text
label 1
menu label ^2) Install CentOS 7 x64 with http://mirror.centos.org Repo
kernel centos7/vmlinuz
append initrd=centos7/initrd.img method=http://mirror.centos.org/centos/7/os/x86_64/ devfs=nomount ip=dhcp
```
is equivalent to:
```json
{
    "mac": "your-mac-address-here",
    "kernel": "http://mirror.centos.org/centos-7/7/os/x86_64/images/pxeboot/vmlinuz",
    "initrd": [ "http://mirror.centos.org/centos-7/7/os/x86_64/images/pxeboot/initrd.img" ],
    "cmdline": "method=http://mirror.centos.org/centos/7/os/x86_64/ devfs=nomount ip=dhcp"
}
```

To boot a machine of your own specification, add the machine's mac address you'd like to boot and provide the pxeboot configurations as demonstrated above.

Once you make your own configuration, lets call it ```awesome-config.json``` don't forget to update the docker-compose.yaml to mount in your file:
```yaml
  spriteful:
     container_name: spriteful
     build:
       context: .
     restart: always
     volumes:
        - ./awesome-config.json:/config/config.json
     ports:
        - "127.0.0.1:5000:5000" 
```

### Booting a machine 
Make sure your host thats running docker is on the same network as the host you're trying to boot and it's as easy as:
```shell
docker-compose up
```
Now sit back and wait for your machine to PXEboot.

To bring down the pxeboot containers run:
```shell
docker-compose down
```
