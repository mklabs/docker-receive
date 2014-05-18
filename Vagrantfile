VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provider :virtualbox do |vb, override|
   vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
   vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
   # Uncomment for smaller machine, and if launching several VM (graphite & jenkins for instance)
   # vb.customize ["modifyvm", :id, "--memory", 512]
   # vb.customize ["modifyvm", :id, "--cpus", 1]
  end

  config.vm.define "docker-opt" do |gs|
    gs.vm.box = "chef/centos-6.5"
    gs.vm.hostname = "dockeropt.dev"

    gs.vm.network :private_network, ip: "192.168.33.30"
    gs.vm.provision "shell", path: "provisioning/install.sh"
  end

end
