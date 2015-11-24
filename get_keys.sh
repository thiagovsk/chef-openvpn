echo "Hostname: $1"
echo "Client Name: $2"
echo "Destination: $3"
scp root@$1:/etc/openvpn/easy-rsa/keys/$2.key $3
scp root@$1:/etc/openvpn/easy-rsa/keys/$2.crt $3
scp root@$1:/etc/openvpn/easy-rsa/keys/client.ovpn $3
scp root@$1:/etc/openvpn/easy-rsa/keys/ca.crt $3

