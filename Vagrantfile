# -*- mode: ruby -*-
# vi: set ft=ruby :

dir = Dir.pwd
vagrant_dir = File.expand_path(File.dirname(__FILE__))

# Vagrantfile API/syntax version.
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here
  # For a complete reference,  please see the online documentation at docs.vagrantup.com/v2/.

  # Default Ubuntu 17.10 Box 
  config.vm.box = "bento/ubuntu-17.10"
  config.vm.hostname = "5genC"

  # Forward Agent
  #
  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true

  # Provision the base Ubuntu box with the Reed CS tools
  config.vm.provision "shell", path: "vagrant-provisioner.sh"

  # Make the synced folder writable for any user in the vagrant group
  config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=775,fmode=774"]

  ### Virtualbox specific configurations are below.
  # Additional options describer here http://docs.vagrantup.com/v2/virtualbox/configuration.html
  config.vm.provider :virtualbox do |vb|
  # Set a custom name in the Virtual Box interface  
    vb.name = "5GenC VirtualMachine"
  # Boot with graphical user interface ("GUI"), this can be commented out if you
  # prefer a non-GUI vm
  # vb.gui = true
  # Increase the memory on the VM is required for successfull compilation of R modules.
    vb.memory = "4096"
  # Increase video memory and turn on 3d accelaration.
    vb.customize ["modifyvm", :id, "--vram", "128"]
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
    vb.cpus = 4
  end
end
