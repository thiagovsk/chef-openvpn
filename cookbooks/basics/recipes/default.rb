package 'openssh-server'
package 'openvpn'
package 'easy-rsa'
#Uncomplicated Firewall (ufw)
package 'uwf'

execute "extract vpn server configuration" do
  command "gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz > /etc/openvpn/server.conf"
end

template "/etc/openvpn/server.conf" do
  source "server_conf.erb"
end

execute "Enable packet forwarding traffic out to the internet" do
  command "echo 1 > /proc/sys/net/ipv4/ip_forward"
end

template "/etc/sysctl.conf" do
  source "sysctl.conf.erb"
end

execute "Allow ssh in ufw" do
  command "ufw allow ssh"
end

execute "Allow UDP in port 1194" do
  command "ufw allow 1194/udp"
end

template "/etc/default/ufw" do
  source "ufw.erb"
end

template "/etc/ufw/before.rules" do
  source "before.rules.erb"
end

execute "Enable ufw" do
  command "ufw --force enable"
end

#execute 'First copy over the Easy-RSA generation scripts' do
#  execute 'cp -r /usr/share/easy-rsa/ /etc/openvpn'
#end
#
#directory "Create key_storage directory" do
#  path 'mkdir /etc/openvpn/easy-rsa/keys'
#  recursive true
#end
#
#execute 'Generate the Diffie-Hellman parameters' do
#  execute 'openssl dhparam -out /etc/openvpn/dh2048.pem 2048'
#end
#
#execute 'Generate the Diffie-Hellman parameters' do
#  execute 'openssl dhparam -out /etc/openvpn/dh2048.pem 2048'
#end
#
