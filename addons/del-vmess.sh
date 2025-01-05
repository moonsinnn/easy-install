#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/usr/local/etc/xray/vmesswstls.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
        echo ""
        echo "You have no existing clients!"
        exit 1
fi

clear
echo ""
echo " Select the existing client you want to remove"
echo " Press CTRL+C to return"
echo " ==============================="
echo "     No  Expired   User"
grep -E "^### " "/usr/local/etc/xray/vmesswstls.json" | cut -d ' ' -f 2-3 | nl -s ') '
until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
        if [[ ${CLIENT_NUMBER} == '1' ]]; then
                read -rp "Select one client [1]: " CLIENT_NUMBER
        else
                read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
        fi
done
user=$(grep -E "^### " "/usr/local/etc/xray/vmesswstls.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/usr/local/etc/xray/vmesswstls.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/vmesswstls.json
sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/vmesswsnontls.json
sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/vmessgrpc.json
rm -f /etc/fuby/vmess/$user-membervmesstls.json /etc/fuby/vmess/$user-membervmessnontls.json /etc/fuby/vmess/$user-membervmessgrpc.json
rm -f /root/akun/vmess/$user.txt
systemctl restart xray@vmesswstls
systemctl restart xray@vmesswsnontls
systemctl restart xray@vmessgrpc
clear
echo " Akun Berhasil Dihapus"
echo " =========================="
echo " Client Name : $user"
echo " Expired On  : $exp"