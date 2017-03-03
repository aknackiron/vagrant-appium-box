# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provision :shell, :path => 'bootstrap.sh', privileged: true
  config.vm.network :forwarded_port, guest: 4723, host: 48011

  config.vm.box = "minimal/xenial64"


  #config.vm.synced_folder "/Users/Shared", "/Share"
  config.vm.provider "virtualbox" do |vb|
    vb.name = "appium-box"
    vb.customize ['modifyvm', :id, '--usb', 'on']
    vb.customize ['modifyvm', :id, '--usbehci', 'on']
#    vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'Samsung device', '--vendorid', '0x04e8']
  end
end
