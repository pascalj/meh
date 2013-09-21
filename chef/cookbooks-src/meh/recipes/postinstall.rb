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
