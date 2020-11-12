<h1 align="center">
0xffsec Web Dōjō
<br>
<small>Web Penetration Testing Lab</small>
</h1>
<p align="center">
<b>dōjō</b> [doꜜː(d)ʑoː] : a hall for immersive learning or meditation.
</p>

## Getting Started

Dōjō is a learning environment
for web applications penetration testing.

The dōjō runs inside a CentOS virtual machine (VM)
and includes a wide collection of vulnerable applications.
Each application runs in isolation, inside the VM, as Docker containers.

The VM is managed by [Vagrant](https://www.vagrantup.com/) using [VirtualBox](https://www.virtualbox.org/) and provisioned with [Ansible](https://www.ansible.com/).

Running applications and their port bindings are set inside [applications.yml](applications.yml). By default running applications include:

- [OWASP JuiceShop](https://owasp.org/www-project-juice-shop/)
- [WebGoat 8.0](https://github.com/WebGoat/WebGoat)

More will be added soon!


## Requirements

- [Vagrant](https://www.vagrantup.com/)

## Usage

Clone the repository:

```sh
git clone https://github.com/0xffsec/webdojo.git
```

Inside the dōjō start and provision the vagrant environment:

```sh
vagrant up
```

:martial_arts_uniform: Done!

- Juice Shop - http://10.0.0.3:3000
- WebGoat 8.0 - http://10.0.0.3:4000

## Contributing

Contributions are welcome, and they are greatly appreciated! Every little bit helps, and credit will always be given.

The best way to send feedback is to file an issue at https://github.com/0xffsec/webdojo/issues
