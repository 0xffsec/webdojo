# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.ssh.insert_key = false

  config.vm.network "private_network", ip: "10.0.0.3"

  config.vm.provider :virtualbox do |v|
    v.name = "0xffsec Web Dōjō"
    v.memory = 1024
    v.cpus = 1
    v.customize ['modifyvm', :id, '--audio', 'none']
  end

  config.vm.provision :ansible_local do |ansible|
    ansible.playbook = "provisioning/playbook.yml"
    ansible.galaxy_role_file = "provisioning/requirements.yml"
  end
end
