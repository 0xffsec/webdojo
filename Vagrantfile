# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.ssh.insert_key = false

  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 4000, host: 4000

  config.vm.provider :virtualbox do |v|
    v.name = "0xffsec Dōjō"
    v.memory = 1024
    v.cpus = 1
    v.customize ['modifyvm', :id, '--audio', 'none']
  end

  config.vm.provision :ansible_local do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.galaxy_role_file = "requirements.yml"
  end
end
