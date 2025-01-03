#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
clear

# Link ENV
domain=$(cat /etc/fuby/domain)
porttls="443"
portnontls="80"
fix=%26
# Method Shadowsocks
method1="aes-128-gcm"
method2="aes-256-gcm"
method3="chacha20-ietf-poly1305"

# Read Info Users
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
        read -rp "User: " -e user
        CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/shadowsocksws.json | wc -l)

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
#WS
###sed -i '/#membershadowsocksws$/a\### '"$user $exp"'\
###},{"password": ''"'"$uuid"'"'',"method": ''"'"$method1"'"'', "level": 0, "email": ''"'"$user"'"''' /usr/local/etc/xray/shadowsocksws.json
###sed -i '/#membershadowsocksws$/a\### '"$user $exp"'\
###},{"password": ''"'"$uuid"'"'',"method": ''"'"$method2"'"'', "level": 0, "email": ''"'"$user"'"''' /usr/local/etc/xray/shadowsocksws.json
sed -i '/#membershadowsocksws$/a\### '"$user $exp"'\
},{"password": ''"'"$uuid"'"'',"method": ''"'"$method3"'"'', "level": 0, "email": ''"'"$user"'"''' /usr/local/etc/xray/shadowsocksws.json
#GRPC
###sed -i '/#membershadowsocksgrpc$/a\### '"$user $exp"'\
###},{"password": ''"'"$uuid"'"'',"method": ''"'"$method1"'"'', "level": 0, "email": ''"'"$user"'"''' /usr/local/etc/xray/shadowsocksgrpc.json
###sed -i '/#membershadowsocksgrpc$/a\### '"$user $exp"'\
###},{"password": ''"'"$uuid"'"'',"method": ''"'"$method2"'"'', "level": 0, "email": ''"'"$user"'"''' /usr/local/etc/xray/shadowsocksgrpc.json
sed -i '/#membershadowsocksgrpc$/a\### '"$user $exp"'\
},{"password": ''"'"$uuid"'"'',"method": ''"'"$method3"'"'', "level": 0, "email": ''"'"$user"'"''' /usr/local/etc/xray/shadowsocksgrpc.json

# Encrypt Method
#encrypt1=$(echo -n "${method1}:${uuid}" | base64 -w0)
#encrypt2=$(echo -n "${method2}:${uuid}" | base64 -w0)
encrypt3=$(echo -n "${method3}:${uuid}" | base64 -w0)

# Converter Shadowsocks
#WS
#shadowsocksws1="ss://${encrypt1}@${domain}:${porttls}?path=%2Fnetzshadowsocks&security=tls&type=ws#${user}"
#shadowsocksws2="ss://${encrypt2}@${domain}:${porttls}?path=%2Fnetzshadowsocks&security=tls&type=ws#${user}"
#shadowsocksws3="ss://${encrypt3}@${domain}:${porttls}?path=%2Fnetzshadowsocks&security=tls&type=ws#${user}"
#GRPC
#shadowsocksgrpc1="ss://${encrypt1}@${domain}:${porttls}?mode=gun&security=tls&type=grpc&serviceName=netzshadowsocksgrpc#${user}"
#shadowsocksgrpc2="ss://${encrypt2}@${domain}:${porttls}?mode=gun&security=tls&type=grpc&serviceName=netzshadowsocksgrpc#${user}"
#shadowsocksgrpc3="ss://${encrypt3}@${domain}:${porttls}?mode=gun&security=tls&type=grpc&serviceName=netzshadowsocksgrpc#${user}"

# CLI RESULT
shadowsockswscli="ss://${encrypt3}@${domain}:${porttls}?path=%2Fnetzshadowsocks&security=tls&type=ws#${user}"
shadowsocksgrpccli="ss://${encrypt3}@${domain}:${porttls}?mode=gun&security=tls&type=grpc&serviceName=netzshadowsocksgrpc#${user}"

# TELEGRAM RESULT
shadowsockswstele="ss://${encrypt3}@${domain}:${porttls}?path=/netzshadowsocks${fix}security=tls${fix}type=ws#${user}"
shadowsocksgrpctele="ss://${encrypt3}@${domain}:${porttls}?mode=gun${fix}security=tls${fix}type=grpc${fix}serviceName=netzshadowsocksgrpc#${user}"

# Cleanup
clear
# Informasi Akun
echo -e ====== Informasi Akun ====== | tee -a /root/akun/shadowsocks/$user.txt
echo -e Client : "$user" | tee -a /root/akun/shadowsocks/$user.txt
echo -e Domain : "$domain" | tee -a /root/akun/shadowsocks/$user.txt
echo -e Expired : "$exp" | tee -a /root/akun/shadowsocks/$user.txt
echo -e ====== Path ======= | tee -a /root/akun/shadowsocks/$user.txt
echo -e "=> WS TLS : /netzshadowsocks" | tee -a /root/akun/shadowsocks/$user.txt
echo -e "=> GRPC   : netzshadowsocksgrpc" | tee -a /root/akun/shadowsocks/$user.txt
echo -e ====== Clipboard ======= | tee -a /root/akun/shadowsocks/$user.txt
echo -e | tee -a /root/akun/shadowsocks/$user.txt
echo -e "=> WS TLS" : "$shadowsockswscli" | tee -a /root/akun/shadowsocks/$user.txt
echo -e | tee -a /root/akun/shadowsocks/$user.txt
echo -e "=> GRPC" : "$shadowsocksgrpccli" | tee -a /root/akun/shadowsocks/$user.txt
echo -e | tee -a /root/akun/shadowsocks/$user.txt
echo -e ====== Rules ======= | tee -a /root/akun/shadowsocks/$user.txt
echo -e "=> No Torrent" | tee -a /root/akun/shadowsocks/$user.txt
echo -e "=> No Seeding" | tee -a /root/akun/shadowsocks/$user.txt
echo -e "=> No Illegal Activity" | tee -a /root/akun/shadowsocks/$user.txt

# Finish
echo -e "Halaman akan ditutup dalam 5-10 detik"
sleep 12
systemctl restart xray@shadowsocksws
systemctl restart xray@shadowsocksgrpc
clear
echo " Saved Sucessfully "
