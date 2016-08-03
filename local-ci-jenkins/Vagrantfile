Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise32"
  config.vm.provision "shell", path: "vagrant_provision.sh"
  config.vm.network "private_network", ip: "192.168.33.20"
  config.vm.network "forwarded_port", guest: 6060, host: 6060
end
