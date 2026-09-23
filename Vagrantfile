Vagrant.configure(2) do |config|
    config.vm.provider :virtualbox do |vb|
		vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
		vb.gui = true
	end
	config.vm.define "devops-box" do |devbox|
		devbox.vm.box = "hashicorp/precise64"
    		#devbox.vm.network "private_network", ip: "192.168.199.9"
            #devbox.vm.hostname = "devops-box"
      		devbox.vm.provision "shell", path: "./installVM.sh"
    		devbox.vm.provider "virtualbox" do |v|
    		  v.memory = 4096
    		  v.cpus = 2
    		end
	end
end
