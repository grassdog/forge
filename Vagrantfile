# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu1310"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/saucy/current/saucy-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.network "forwarded_port", guest: 80, host: 8888

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
    # If you are using VirtualBox, you might want to enable NFS for shared folders
    # config.cache.enable_nfs  = true
  end
end
