<h1 align="center">
Web Dōjō
<br>
<small>Web Penetration Testing Lab</small>
</h1>
<p align="center">
<b>dōjō</b> [doꜜː(d)ʑoː] : a hall for immersive learning or meditation.
</p>

## Overview

Web Dōjō is a learning and testing environment
for web application hacking and pentesting.

The lab includes a collection of [vulnerable applications](#available-applications)
easy accessible through a [landing page](#the-dojo).

## Available Applications

- [Damn Vulnerable Web App (DVWA)](http://dvwa.co.uk/)
- [OWASP JuiceShop](https://owasp.org/www-project-juice-shop/)
- [WebGoat 8.0](https://github.com/WebGoat/WebGoat)
- [Damn Vulnerable NodeJS Application](https://github.com/appsecco/dvna)

## Quick Start

```sh
curl -sSL git.io/webdojo-install | bash
```

## Manual Installation

The lab can be deployed either with [Vagrant](https://www.vagrantup.com/) on its own VM
or on any machine running [Docker](https://www.docker.com/).

Clone and browse the repository:

```sh
git clone https://github.com/0xffsec/webdojo.git
cd webdojo
```

#### Wizard

```sh
./install.sh
```

#### Using Vagrant (preferred)

Requirements: [Vagrant](https://www.vagrantup.com/docs/installation) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads).

```sh
vagrant up
```

:martial_arts_uniform: Done!\
The dojo will be available at http://10.0.0.3

#### Using Docker Compose

Requirements: [Docker](https://docs.docker.com/get-docker/).

```sh
docker-compose up -d
```

:martial_arts_uniform: Done!\
The dojo will be available at http://127.0.0.1

## The Dojo

The dojo is a web application
that serves as a menu for the available apps.

## VirtualBox Network

When using Vagrant,
the installation creates a [Host-Only Network](https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/network_hostonly.html) with address `10.0.0.1/24`
and DHCP disabled.
The VM is attached to the network with the static IP `10.0.0.3`.

```sh
$ vboxmanage list hostonlyifs

Name:            vboxnet3
GUID:            786f6276-656e-4474-8000-0a0027000004
DHCP:            Disabled
IPAddress:       10.0.0.1
NetworkMask:     255.255.255.0
…
```

If your pentesting machine lives in a different VM,
add a new adaptor to it and attach it to the newly created network.

**The IP has to be manually set inside the VM.**

![VirtualBox Network Dialog](../assets/vb_network.png?raw=true)

## Other Considerations

#### Why Docker Compose

Containers were initially built and started
by iterating through a YAML file.
Docker Compose
removes complexity from the provisioner
while adding flexibility to the deployment.
This modularization allows not only to deploy on a VM
but on any system running Docker.

## Contributing

Contributions are welcome, and they are greatly appreciated! Every little bit helps, and credit will always be given.

The best way to send feedback is to file an issue at https://github.com/0xffsec/webdojo/issues
