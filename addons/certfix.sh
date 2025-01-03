#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
clear

# PKG
apt update && upgrade
apt install git -y

# Remove Necesarry Files
rm -f /etc/fuby/fuby.crt
rm -f /etc/fuby/fuby.key
rm -f /etc/fuby/domain
rm -f /root/domain

# Command
echo "Masukan Domain Baru Kamu"
read -p "Hostname / Domain: " host
echo "$host" >>/etc/fuby/domain
echo "$host" >>/root/domain

# ENV
domain=$(cat /root/domain)

# Clone Acme
ufw disable
git clone https://github.com/acmesh-official/acme.sh.git /etc/acme
cd /etc/acme
systemctl stop nginx
systemctl stop xray@vmesswsnontls
chmod +x acme.sh
./acme.sh --set-default-ca --server letsencrypt
./acme.sh --register-account -m netz@$domain
./acme.sh --issue -d $domain --standalone --server letsencrypt --force
./acme.sh --installcert -d $domain --key-file /etc/fuby/fuby.key --fullchain-file /etc/fuby/fuby.crt

# Restart Service
rm -f /root/domain
systemctl restart nginx
systemctl restart xray@vmesswsnontls
