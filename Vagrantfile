# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "freebsd91"
  config.vm.box_url = "https://s3.amazonaws.com/vagrant_boxen/freebsd_amd64_zfs.box"

  # Private network for NFS
  config.vm.network :private_network, ip: "10.0.0.2"

  # configure the NICs
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
  end
  
  # use NFS for the synced folder
  config.vm.synced_folder ".", "/vagrant", :nfs => true

  # Yes, that is a _very_ dirty hack. When git 1.8.4 comes out
  # this can be removed. Hey, it's a temporary dev machine...
  config.vm.provision :shell, inline: 'chmod -R 777 /root/'

  # because Ubuntu has this directories, all others must have it too, right?
  config.vm.provision :shell, inline: 'mkdir -p /etc/profile.d/'
  config.vm.provision :shell, inline: 'mkdir -p /usr/local/src'

  config.vm.provision :chef_solo do |chef|
    chef.nfs = true
    chef.roles_path = [[:host, 'chef/roles']]
    chef.add_role 'meh'
    chef.json = {
      'rbenv' => {
      'user_installs' => [{
        'user' => 'vagrant',
        'global' => '1.9.3-p327',
        'rubies' => ['1.9.3-p327'],
	'upgrade' => true,
        'gems' => {
          '1.9.3-p327' => [
	    { 'name' => 'bundler' }
          ]
        }
      }]
      },
      'mysql' => {
      	'server_root_password' => 'meh',
	'server_debian_password' => 'meh',
	'server_repl_password' => 'meh',
	'basedir' => '/usr/local'
      }
    }
    chef.cookbooks_path = ["chef/cookbooks","chef/cookbooks-src"]
  end
end
