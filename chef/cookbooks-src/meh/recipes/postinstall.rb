# create a simple user to create the database for development
execute "create database user" do
  command "mysql -u root -p#{node['mysql']['server_root_password']} -e 'CREATE USER meh'"
  command "mysql -u root -p#{node['mysql']['server_root_password']} -e 'GRANT ALL PRIVILEGES ON *.* TO \"meh\"@\"localhost\"'"
end

ruby_block "Enable rbenv for user vagrant" do
  block do
    f = Chef::Util::FileEdit.new("/home/vagrant/.bash_profile")
    f.insert_line_if_no_match(/.rbenv/, <<-EOH
source /etc/profile.d/rbenv.sh
EOH
    )
    f.write_file
  end
  only_if { ::File.exists?("/home/vagrant/.bash_profile") }
end
