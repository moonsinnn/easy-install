#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
# Link ENV
domain=$(cat /etc/fuby/domain)
porttls="443"
portnontls="80"

# Read Info Users
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
        read -rp "User: " -e user
        CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/vmesswstls.json | wc -l)

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
sed -i '/#membervmesswstls$/a\### '"$user $exp"'\
},{"email": ''"'"$user"'"'',"id": ''"'"$uuid"'"'', "level": 1, "alterId": 0' /usr/local/etc/xray/vmesswstls.json
sed -i '/#membervmesswsnontls$/a\### '"$user $exp"'\
},{"email": ''"'"$user"'"'',"id": ''"'"$uuid"'"'', "level": 1, "alterId": 0' /usr/local/etc/xray/vmesswsnontls.json
sed -i '/#membervmessgrpc$/a\### '"$user $exp"'\
},{"email": ''"'"$user"'"'',"id": ''"'"$uuid"'"'', "level": 1' /usr/local/etc/xray/vmessgrpc.json

# Vmess Encryption
cat >/etc/fuby/vmess/$user-membervmesstls.json <<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${porttls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "netzvmess",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF
cat >/etc/fuby/vmess/$user-membervmessnontls.json <<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${portnontls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "netzvmess",
      "type": "none",
      "host": "",
      "tls": "none"
}
EOF
cat >/etc/fuby/vmess/$user-membervmessgrpc.json <<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${porttls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "netzvmessgrpc",
      "type": "gun",
      "host": "",
      "tls": "tls"
}
EOF

### Creator Link
# Vmess
vmesswstls="vmess://$(base64 -w 0 /etc/fuby/vmess/$user-membervmesstls.json)"
vmesswsnontls="vmess://$(base64 -w 0 /etc/fuby/vmess/$user-membervmessnontls.json)"
vmessgrpc="vmess://$(base64 -w 0 /etc/fuby/vmess/$user-membervmessgrpc.json)"

# Cleanup Process
clear
# Informasi Akun
echo -e ====== Informasi Akun ====== | tee -a /root/akun/vmess/$user.txt
echo -e Client : "$user" | tee -a /root/akun/vmess/$user.txt
echo -e UUID : "$uuid" | tee -a /root/akun/vmess/$user.txt
echo -e Domain : "$domain" | tee -a /root/akun/vmess/$user.txt
echo -e alterId : "0" | tee -a /root/akun/vmess/$user.txt
echo -e Expired : "$exp" | tee -a /root/akun/vmess/$user.txt
echo -e ====== Path ======= | tee -a /root/akun/vmess/$user.txt
echo -e "=> WS TLS : netzvmess" | tee -a /root/akun/vmess/$user.txt
echo -e "=> NO TLS : netzvmess" | tee -a /root/akun/vmess/$user.txt
echo -e "=> GRPC   : netzvmessgrpc" | tee -a /root/akun/vmess/$user.txt
echo -e ====== Clipboard ======= | tee -a /root/akun/vmess/$user.txt
echo -e | tee -a /root/akun/vmess/$user.txt
echo -e "=> WS TLS" : "$vmesswstls" | tee -a /root/akun/vmess/$user.txt
echo -e | tee -a /root/akun/vmess/$user.txt
echo -e "=> NO TLS" : "$vmesswsnontls" | tee -a /root/akun/vmess/$user.txt
echo -e | tee -a /root/akun/vmess/$user.txt
echo -e "=> GRPC" : "$vmessgrpc" | tee -a /root/akun/vmess/$user.txt
echo -e | tee -a /root/akun/vmess/$user.txt
echo -e ====== Rules ======= | tee -a /root/akun/vmess/$user.txt
echo -e "=> No Torrent" | tee -a /root/akun/vmess/$user.txt
echo -e "=> No Seeding" | tee -a /root/akun/vmess/$user.txt
echo -e "=> No Illegal Activity" | tee -a /root/akun/vmess/$user.txt

# Finish
echo -e "Halaman akan ditutup dalam 5-10 detik"
sleep 12
systemctl restart xray@vmesswstls
systemctl restart xray@vmesswsnontls
systemctl restart xray@vmessgrpc
clear
