#/bin/bash
###get the value with runme.sh token
curl -s https://api.nsrvs.com/tokens/$1 >/tmp/$1
#grep -Po '"'"ovpncrt"'"\s*:\s*"\K([^"]*)' /tmp/$1 >  /tmp/ovpncrt
#grep -Po '"'"ovpnkey"'"\s*:\s*"\K([^"]*)' /tmp/$1 >  /tmp/ovpnkey
#grep -Po '"'"sshpub"'"\s*:\s*"\K([^"]*)' /tmp/$1 >  /tmp/sshpub
#grep -Po '"'"sshkey"'"\s*:\s*"\K([^"]*)' /tmp/$1 >  /tmp/sshkey
NOVPNCRT=$(grep -Po '"'"ovpncrt"'"\s*:\s*"\K([^"]*)' /tmp/$1)
NOVPNKEY=$(grep -Po '"'"ovpnkey"'"\s*:\s*"\K([^"]*)' /tmp/$1)
NSSHPUB=$(grep -Po '"'"sshpub"'"\s*:\s*"\K([^"]*)' /tmp/$1)
NSSHKEY=$(grep -Po '"'"sshkey"'"\s*:\s*"\K([^"]*)' /tmp/$1)
#NOPVNSRVID=$(grep -Po '"'"ovpnserver_id"'"\s*:\s*"\K([^"]*)' /tmp/$1)
NOPVNSRVID=$(grep -Po '"ovpnserver_id":(\d*?,|.*?[^\\]",)' /tmp/26BBE7AC|grep -o '[0-9]*')
#rm -rf /tmp/$1
curl -s https://api.nsrvs.com/ovpnsrvr/$NOPVNSRVID > /tmp/ovpn-srv.conf
NOVPNSIP=$(grep -Po '"'"serverip"'"\s*:\s*"\K([^"]*)' /tmp/ovpn-srv.conf)
NOVPNSPORT=$(grep -Po '"'"serverport"'"\s*:\s*"\K([^"]*)' /tmp/ovpn-srv.conf)
NOVPNCA=$(grep -Po '"'"ca"'"\s*:\s*"\K([^"]*)' /tmp/ovpn-srv.conf)
NOVPNTLS=$(grep -Po '"'"tls-auth"'"\s*:\s*"\K([^"]*)' /tmp/ovpn-srv.conf)
CLIENT_FILE="$(cat <<EOF
##created by ninstaller
client
nobind
dev tun
remote-cert-tls server

remote $NOVPNSIP $NOVPNSPORT udp

<key>
$NOVPNKEY
</key>
<cert>
$NOVPNCRT
</cert>
<ca>
$NOVPNCA
</ca>
key-direction 1
<tls-auth>
$NOVPNTLS
</tls-auth>

redirect-gateway def1
EOF
)"
echo "$CLIENT_FILE" >/tmp/client.ovpn
sed -i 's/\\n/\'$'\n''/g' /tmp/client.ovpn
