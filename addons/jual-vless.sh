#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
# Link ENV
domain=$(cat /etc/fuby/domain)
porttls="443"

# Read Info Users
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
        read -rp "User: " -e user
        CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/vlesswstls.json | wc -l)

        if [[ ${CLIENT_EXISTS} == '2' ]]; then
                echo ""
                echo "User ini telah ada, Tolong gunakan nama lain."
                exit 1
        fi
done
uuid=$(xray uuid)
read -p "Expired (days): " masaaktif
exp=$(date -d "$masaaktif days" +"%Y-%m-%d")

# Buat Akun
sed -i '/#membervlesswstls$/a\### '"$user $exp"'\
},{"email": ''"'"$user"'"'',"id": ''"'"$uuid"'"'', "level": 1, "alterId": 0' /usr/local/etc/xray/vlesswstls.json
sed -i '/#membervlessgrpc$/a\### '"$user $exp"'\
},{"email": ''"'"$user"'"'',"id": ''"'"$uuid"'"'', "level": 1' /usr/local/etc/xray/vlessgrpc.json

### Creator Link
# Vless
vlesswstls="vless://${uuid}@${domain}:$porttls?path=netzvless&security=tls&encryption=none&type=ws#${user}"
vlessgrpc="vless://${uuid}@${domain}:$porttls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=netzvlessgrpc#${user}"

# Cleanup Process
clear
# Informasi Akun
echo -e ====== Informasi Akun ====== | tee -a /root/akun/vless/$user.txt
echo -e Client : "$user" | tee -a /root/akun/vless/$user.txt
echo -e UUID : "$uuid" | tee -a /root/akun/vless/$user.txt
echo -e Domain : "$domain" | tee -a /root/akun/vless/$user.txt
echo -e alterId : "0" | tee -a /root/akun/vless/$user.txt
echo -e Expired : "$exp" | tee -a /root/akun/vless/$user.txt
echo -e ====== Path ======= | tee -a /root/akun/vless/$user.txt
echo -e "=> WS TLS : netzvless" | tee -a /root/akun/vless/$user.txt
echo -e "=> GRPC   : netzvlessgrpc" | tee -a /root/akun/vless/$user.txt
echo -e ====== Clipboard ======= | tee -a /root/akun/vless/$user.txt
echo -e | tee -a /root/akun/vless/$user.txt
echo -e "=> WS TLS" : "$vlesswstls" | tee -a /root/akun/vless/$user.txt
echo -e | tee -a /root/akun/vless/$user.txt
echo -e "=> GRPC" : "$vlessgrpc" | tee -a /root/akun/vless/$user.txt
echo -e | tee -a /root/akun/vless/$user.txt
echo -e ====== Rules ======= | tee -a /root/akun/vless/$user.txt
echo -e "=> No Torrent" | tee -a /root/akun/vless/$user.txt
echo -e "=> No Seeding" | tee -a /root/akun/vless/$user.txt
echo -e "=> No Illegal Activity" | tee -a /root/akun/vless/$user.txt

# Finish
echo -e "Halaman akan ditutup dalam 5-10 detik"
sleep 12
systemctl restart xray@vlesswstls
systemctl restart xray@vlessgrpc
clear
