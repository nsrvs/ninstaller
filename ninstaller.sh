#/bin/bash
#
#
#
#   curl -sSL https://install.nsrvs.net | bash
#
#
#
#script has the following parts
# 1. check the key that is entered (get the values)
# 2. check the operating system
# 3. check if rkt (docker) is installed or not
# 4. depending on the OS install docker(rkt)
# 5. ask for approval about the operations that is to be done on the host = are you sure ?
# 6. ask for .authorized_keys access 
# 7. use the openvpn+ssh keys to start the container 
# 

set -e 


##DNS servers
# List of supported DNS servers
DNS_SERVERS=$(cat << EOM
Google (ECS);8.8.8.8;8.8.4.4;2001:4860:4860:0:0:0:0:8888;2001:4860:4860:0:0:0:0:8844
OpenDNS (ECS);208.67.222.222;208.67.220.220;2620:0:ccc::2;2620:0:ccd::2
Level3;4.2.2.1;4.2.2.2;;
Comodo;8.26.56.26;8.20.247.20;;
DNS.WATCH;84.200.69.80;84.200.70.40;2001:1608:10:25:0:0:1c04:b12f;2001:1608:10:25:0:0:9249:d69b
Quad9 (filtered, DNSSEC);9.9.9.9;149.112.112.112;2620:fe::fe;2620:fe::9
Quad9 (unfiltered, no DNSSEC);9.9.9.10;149.112.112.10;2620:fe::10;2620:fe::fe:10
Quad9 (filtered + ECS);9.9.9.11;149.112.112.11;2620:fe::11;
Cloudflare;1.1.1.1;1.0.0.1;2606:4700:4700::1111;2606:4700:4700::1001
EOM
)


INSTALL_LOG=/tmp/nsrvs-ninstaller.log


##test commit from code