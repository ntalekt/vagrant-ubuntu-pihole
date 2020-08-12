#!/bin/bash
mkdir /etc/pihole
touch /etc/pihole/setupVars.conf
tee /etc/pihole/setupVars.conf > /dev/null << EOF
  WEBPASSWORD=$1
  CONDITIONAL_FORWARDING=false
  PIHOLE_INTERFACE=eth0
  IPV4_ADDRESS=$2
  IPV6_ADDRESS=
  QUERY_LOGGING=true
  INSTALL_WEB_SERVER=true
  INSTALL_WEB_INTERFACE=true
  LIGHTTPD_ENABLED=true
  DNSMASQ_LISTENING=single
  PIHOLE_DNS_1=$3
  PIHOLE_DNS_2=$4
  DNS_FQDN_REQUIRED=true
  DNS_BOGUS_PRIV=true
  DNSSEC=false
  REV_SERVER=false
  BLOCKING_ENABLED=true
EOF

echo -e "\e[33m**********\e[39mBegin modding resolv.conf\e[33m**********\e[39m"
sudo sed -i_bak 's/nameserver.*/nameserver 1.1.1.1/' /etc/resolv.conf
echo -e "\e[33m**********\e[39mEnd modding resolv.conf\e[33m**********\e[39m"

# Install pihole using unattended flag
echo -e "\e[33m**********\e[39mBegin pihole install\e[33m**********\e[39m"
wget -O basic-install.sh https://install.pi-hole.net
chmod +x basic-install.sh
sudo bash basic-install.sh --unattended
echo -e "\e[33m**********\e[39mEnd pihole install\e[33m**********\e[39m"

sudo rm basic-install.sh

echo -e "\e[33m**********\e[39mBegin ssh key\e[33m**********\e[39m"
sudo apt-get install sshpass -y
sudo -Hu vagrant echo "$6" > /home/vagrant/password.txt
sudo -Hu vagrant ssh-keygen -t rsa -q -f "/home/vagrant/.ssh/id_rsa" -N ""
sudo sshpass -f /home/vagrant/password.txt ssh-copy-id -f -i /home/vagrant/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ubuntu@$5
echo -e "\e[33m**********\e[39mEnd ssh key\e[33m**********\e[39m"

echo -e "\e[33m**********\e[39mBegin rsync gravity.db\e[33m**********\e[39m"
sudo rsync -Paiv -e "ssh -i /home/vagrant/.ssh/id_rsa" ubuntu@$5:/etc/pihole/gravity.db /etc/pihole/gravity.db
pihole restartdns reload-lists
echo -e "\e[33m**********\e[39mEnd rsync gravity.db\e[33m**********\e[39m"

echo -e "\e[33m**********\e[39mBegin rsync hosts\e[33m**********\e[39m"
sudo rsync -Paiv -e "ssh -i /home/vagrant/.ssh/id_rsa" ubuntu@$5:/etc/hosts /etc/hosts
pihole restartdns
echo -e "\e[33m**********\e[39mEnd rsync hosts\e[33m**********\e[39m"

# configure the motd.
# NB this was generated at http://patorjk.com/software/taag/#p=display&f=Star%20Wars&t=pihole%0Aserver.
cat > /etc/motd <<'EOF'
.______    __   __    __    ______    __       _______
|   _  \  |  | |  |  |  |  /  __  \  |  |     |   ____|
|  |_)  | |  | |  |__|  | |  |  |  | |  |     |  |__
|   ___/  |  | |   __   | |  |  |  | |  |     |   __|
|  |      |  | |  |  |  | |  `--'  | |  `----.|  |____
| _|      |__| |__|  |__|  \______/  |_______||_______|

     _______. _______ .______     ____    ____  _______ .______
    /       ||   ____||   _  \    \   \  /   / |   ____||   _  \
   |   (----`|  |__   |  |_)  |    \   \/   /  |  |__   |  |_)  |
    \   \    |   __|  |      /      \      /   |   __|  |      /
.----)   |   |  |____ |  |\  \----.  \    /    |  |____ |  |\  \----.
|_______/    |_______|| _| `._____|   \__/     |_______|| _| `._____|

EOF
