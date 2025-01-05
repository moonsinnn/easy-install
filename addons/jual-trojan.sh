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
        CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/trojanwstls.json | wc -l)

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
sed -i '/#membertrojanwstls$/a\### '"$user $exp"'\
},{"email": ''"'"$user"'"'',"password": ''"'"$user"'"'', "level": 1' /usr/local/etc/xray/trojanwstls.json
sed -i '/#membertrojangrpc$/a\### '"$user $exp"'\
},{"email": ''"'"$user"'"'',"password": ''"'"$user"'"'', "level": 1' /usr/local/etc/xray/trojangrpc.json

### Creator Link
# Trojan
trojanwstls="trojan://${user}@${domain}:$porttls?path=netztrojan&security=tls&type=ws#${user}"
trojangrpc="trojan://${user}@${domain}:$porttls?mode=gun&security=tls&type=grpc&serviceName=netztrojangrpc#${user}"

# Cleanup Process
clear
# Informasi Akun
echo -e ====== Informasi Akun ====== | tee -a /root/akun/trojan/$user.txt
echo -e Client : "$user" | tee -a /root/akun/trojan/$user.txt
echo -e Domain : "$domain" | tee -a /root/akun/trojan/$user.txt
echo -e Expired : "$exp" | tee -a /root/akun/trojan/$user.txt
echo -e ====== Path ======= | tee -a /root/akun/trojan/$user.txt
echo -e "=> WS TLS : netztrojan" | tee -a /root/akun/trojan/$user.txt
echo -e "=> GRPC   : netztrojangrpc" | tee -a /root/akun/trojan/$user.txt
echo -e ====== Clipboard ======= | tee -a /root/akun/trojan/$user.txt
echo -e | tee -a /root/akun/trojan/$user.txt
echo -e "=> WS TLS" : "$trojanwstls" | tee -a /root/akun/trojan/$user.txt
echo -e | tee -a /root/akun/trojan/$user.txt
echo -e "=> GRPC" : "$trojangrpc" | tee -a /root/akun/trojan/$user.txt
echo -e | tee -a /root/akun/trojan/$user.txt
echo -e ====== Rules ======= | tee -a /root/akun/trojan/$user.txt
echo -e "=> No Torrent" | tee -a /root/akun/trojan/$user.txt
echo -e "=> No Seeding" | tee -a /root/akun/trojan/$user.txt
echo -e "=> No Illegal Activity" | tee -a /root/akun/trojan/$user.txt

# Finish
echo -e "Halaman akan ditutup dalam 5-10 detik"
sleep 12
systemctl restart xray@trojanwstls
systemctl restart xray@trojangrpc
clear
