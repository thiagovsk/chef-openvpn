package 'openssh-server'
package 'openvpn'
package 'easy-rsa'
#Uncomplicated Firewall (ufw)
package 'ufw'

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

execute "Allow TCP in port 443" do
  command "ufw allow 443/tcp"
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

execute 'First copy over the Easy-RSA generation scripts' do
  command 'cp -r /usr/share/easy-rsa/ /etc/openvpn'
end

directory "Create key_storage directory" do
  path 'mkdir /etc/openvpn/easy-rsa/keys'
  recursive true
end

execute 'Generate the Diffie-Hellman parameters' do
  command 'openssl dhparam -out /etc/openvpn/dh2048.pem 2048'
end

bash 'Initialize the PKI (Public Key Infrastructure)' do
  user 'root'
  cwd '/etc/openvpn/easy-rsa'
  code <<-EOH
  . ./vars
  EOH
end

execute 'clear the working directory of any possible old or example keys' do
  command './clean-all'
  cwd '/etc/openvpn/easy-rsa'
end

template "/etc/openvpn/easy-rsa/build-ca" do
  source "build.ca.erb"
end

execute 'Build certificate' do
  command './build-ca'
  cwd '/etc/openvpn/easy-rsa'
end

template "/etc/openvpn/easy-rsa/build-key-server" do
  source "build-key-server.erb"
end

bash 'Build key server' do
  user 'root'
  cwd '/etc/openvpn/easy-rsa'
  code <<-EOH
  ./build-ca
  ./build-key-server server
  EOH
end


bash 'OpenVPN expects to see the CA, certificate and key in /etc/openvpn' do
  user 'root'
  code <<-EOH
  cp /etc/openvpn/easy-rsa/keys/{server.crt,server.key,ca.crt} /etc/openvpn
  EOH
end

service "openvpn" do
  action :start
end

template "/etc/openvpn/easy-rsa/build-key" do
  source "build-key.erb"
end

execute 'Build certificate to client 1' do
  command './build-key client1'
  cwd '/etc/openvpn/easy-rsa'
end

execute 'Build certificate to client 2' do
  command './build-key client2'
  cwd '/etc/openvpn/easy-rsa'
end

execute 'Build certificate to client 3' do
  command './build-key client3'
  cwd '/etc/openvpn/easy-rsa'
end

execute 'changing the name of the example file from client.conf to client.ovpn' do
  command 'cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf /etc/openvpn/easy-rsa/keys/client.ovpn'
end
