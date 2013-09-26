# get ports tree
portsnap_opts = ::File.exists?("/usr/ports/devel") ? "update" : "fetch extract"

execute "Manage Ports Tree - #{portsnap_opts}" do
  command <<-EOS
    sed -e 's/\\[ ! -t 0 \\]/false/' /usr/sbin/portsnap > /tmp/portsnap
    chmod +x /tmp/portsnap
    /tmp/portsnap #{portsnap_opts}
  EOS
end

%w{
  gmake
  autoconf
  m4
}.each do |pkg|
  package pkg
end

ruby_block "Disable make parallelization system-wide" do
  block do
    f = Chef::Util::FileEdit.new("/etc/make.conf")
    f.insert_line_if_no_match(/.MAKEFLAGS:/, <<-EOH

.MAKEFLAGS: -B
EOH
    )
    f.write_file
  end
  only_if { ::File.exists?("/etc/make.conf") }
end

# rails needs node for the assets
# and the node recipes suck
package "node"
package "streamripper"
package "redis"
service "redis" do
  action :disable
end
service "redis" do 
  action :start
end
