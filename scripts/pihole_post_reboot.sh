#!/bin/bash

echo -e "\e[33m**********\e[39mBegin modding resolv.conf\e[33m**********\e[39m"
sudo sed -i_bak '/nameserver 1.1.1.1/d' /etc/resolv.conf
sudo sed -i_bak 's/nameserver.*/nameserver 127.0.0.1/' /etc/resolv.conf
echo -e "\e[33m**********\e[39mEnd modding resolv.conf\e[33m**********\e[39m"

sudo rm /home/vagrant/password.txt
