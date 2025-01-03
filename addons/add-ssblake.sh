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
method10="2022-blake3-aes-128-gcm"
method11="2022-blake3-aes-256-gcm"
method12="2022-blake3-chacha20-poly1305"

# Read Info Users
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
        read -rp "User: " -e user
        CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/ssblakews.json | wc -l)

        if [[ ${CLIENT_EXISTS} == '2' ]]; then
                echo ""
                echo "User ini telah ada, Tolong gunakan nama lain."
                exit 1
        fi
done
uuid=$(xray uuid)
genid=$(openssl rand -base64 16)
serverid="CXX4y7hOW6XlLygCsx0U1w=="
read -p "Expired (days): " masaaktif
exp=$(date -d "$masaaktif days" +"%Y-%m-%d")

# Buat Akun
#WS
###sed -i '/#memberblakews$/a\### '"$user $exp"'\
###},{"password": ''"'"$uuid"'"'',"method": ''"'"$method1"'"'', "level": 0, "email": ''"'"$user"'"''' /usr/local/etc/xray/ssblakews.json
###sed -i '/#memberblakews$/a\### '"$user $exp"'\
###},{"password": ''"'"$uuid"'"'',"method": ''"'"$method2"'"'', "level": 0, "email": ''"'"$user"'"''' /usr/local/etc/xray/ssblakews.json
###sed -i '/#memberblakews$/a\### '"$user $exp"'\
###},{"password": ''"'"$uuid"'"'',"method": ''"'"$method3"'"'', "level": 0, "email": ''"'"$user"'"''' /usr/local/etc/xray/ssblakews.json
# WS 2022
sed -i '/#memberblakews$/a\### '"$user $exp"'\
},{"password": ''"'"$genid"'"'', "email": ''"'"$user"'"''' /usr/local/etc/xray/ssblakews.json

#GRPC
###sed -i '/#memberblakegrpc$/a\### '"$user $exp"'\
###},{"password": ''"'"$uuid"'"'',"method": ''"'"$method1"'"'', "level": 0, "email": ''"'"$user"'"''' /usr/local/etc/xray/ssblakegrpc.json
###sed -i '/#memberblakegrpc$/a\### '"$user $exp"'\
###},{"password": ''"'"$uuid"'"'',"method": ''"'"$method2"'"'', "level": 0, "email": ''"'"$user"'"''' /usr/local/etc/xray/ssblakegrpc.json
###sed -i '/#memberblakegrpc$/a\### '"$user $exp"'\
###},{"password": ''"'"$uuid"'"'',"method": ''"'"$method3"'"'', "level": 0, "email": ''"'"$user"'"''' /usr/local/etc/xray/ssblakegrpc.json
# GRPC 2022
sed -i '/#memberblakegrpc$/a\### '"$user $exp"'\
},{"password": ''"'"$genid"'"'', "email": ''"'"$user"'"''' /usr/local/etc/xray/ssblakegrpc.json

# Encrypt Method
#encrypt1=$(echo -n "${method1}:${uuid}" | base64 -w0)
#encrypt2=$(echo -n "${method2}:${uuid}" | base64 -w0)
#encrypt3=$(echo -n "${method3}:${uuid}" | base64 -w0)
encrypt10=$(echo -n "${method10}:${serverid}:${genid}" | base64 -w0)

# Converter Shadowsocks
#WS
#ssblakews1="ss://${encrypt1}@${domain}:${porttls}?path=%2Fnetzblakews&security=tls&type=ws#${user}"
#ssblakews2="ss://${encrypt2}@${domain}:${porttls}?path=%2Fnetzblakews&security=tls&type=ws#${user}"
#ssblakews3="ss://${encrypt3}@${domain}:${porttls}?path=%2Fnetzblakews&security=tls&type=ws#${user}"
#GRPC
#ssblakegrpc1="ss://${encrypt1}@${domain}:${porttls}?mode=gun&security=tls&type=grpc&serviceName=netzblakegrpc#${user}"
#ssblakegrpc2="ss://${encrypt2}@${domain}:${porttls}?mode=gun&security=tls&type=grpc&serviceName=netzblakegrpc#${user}"
#ssblakegrpc3="ss://${encrypt3}@${domain}:${porttls}?mode=gun&security=tls&type=grpc&serviceName=netzblakegrpc#${user}"

# CLI RESULT
ssblakewscli="ss://${encrypt10}@${domain}:${porttls}?path=%2Fnetzblakews&security=tls&type=ws#${user}"
ssblakegrpccli="ss://${encrypt10}@${domain}:${porttls}?mode=gun&security=tls&type=grpc&serviceName=netzblakegrpc#${user}"

# TELEGRAM RESULT
ssblakewstele="ss://${encrypt10}@${domain}:${porttls}?path=/netzblakews${fix}security=tls${fix}type=ws#${user}"
ssblakegrpctele="ss://${encrypt10}@${domain}:${porttls}?mode=gun${fix}security=tls${fix}type=grpc${fix}serviceName=netzblakegrpc#${user}"

# Cleanup
clear
# Informasi Akun
echo -e ====== Informasi Akun ====== | tee -a /root/akun/shadowsocksblake/$user.txt
echo -e Client : "$user" | tee -a /root/akun/shadowsocksblake/$user.txt
echo -e Domain : "$domain" | tee -a /root/akun/shadowsocksblake/$user.txt
echo -e Expired : "$exp" | tee -a /root/akun/shadowsocksblake/$user.txt
echo -e ====== Path ======= | tee -a /root/akun/shadowsocksblake/$user.txt
echo -e "=> WS TLS : /netzblakews" | tee -a /root/akun/shadowsocksblake/$user.txt
echo -e "=> GRPC   : netzblakegrpc" | tee -a /root/akun/shadowsocksblake/$user.txt
echo -e ====== Clipboard ======= | tee -a /root/akun/shadowsocksblake/$user.txt
echo -e | tee -a /root/akun/shadowsocksblake/$user.txt
echo -e "=> WS TLS" : "$ssblakewscli" | tee -a /root/akun/shadowsocksblake/$user.txt
echo -e | tee -a /root/akun/shadowsocksblake/$user.txt
echo -e "=> GRPC" : "$ssblakegrpccli" | tee -a /root/akun/shadowsocksblake/$user.txt
echo -e | tee -a /root/akun/shadowsocksblake/$user.txt
echo -e ====== Rules ======= | tee -a /root/akun/shadowsocksblake/$user.txt
echo -e "=> No Torrent" | tee -a /root/akun/shadowsocksblake/$user.txt
echo -e "=> No Seeding" | tee -a /root/akun/shadowsocksblake/$user.txt
echo -e "=> No Illegal Activity" | tee -a /root/akun/shadowsocksblake/$user.txt

# Finish
echo -e "Halaman akan ditutup dalam 5-10 detik"
sleep 12
systemctl restart xray@ssblakews
systemctl restart xray@ssblakegrpc
clear
echo " Saved Sucessfully "
