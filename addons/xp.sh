#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
# Vmess
data=($(cat /usr/local/etc/xray/vmesswstls.json | grep '^###' | cut -d ' ' -f 2))
now=$(date +"%Y-%m-%d")
for user in "${data[@]}"; do
        exp=$(grep -w "^### $user" "/usr/local/etc/xray/vmesswstls.json" | cut -d ' ' -f 3)
        d1=$(date -d "$exp" +%s)
        d2=$(date -d "$now" +%s)
        exp2=$(((d1 - d2) / 86400))
        if [[ $exp2 == "0" ]]; then
                sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/vmesswstls.json
                sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/vmesswsnontls.json
                sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/vmessgrpc.json
                rm -f /etc/fuby/vmess/$user-membervmesstls.json /etc/fuby/vmess/$user-membervmessnontls.json /etc/fuby/vmess/$user-membervmessgrpc.json
        fi
done
systemctl restart xray@vmesswstls
systemctl restart xray@vmesswsnontls
systemctl restart xray@vmessgrpc

# Vless
data=($(cat /usr/local/etc/xray/vlesswstls.json | grep '^###' | cut -d ' ' -f 2))
now=$(date +"%Y-%m-%d")
for user in "${data[@]}"; do
        exp=$(grep -w "^### $user" "/usr/local/etc/xray/vlesswstls.json" | cut -d ' ' -f 3)
        d1=$(date -d "$exp" +%s)
        d2=$(date -d "$now" +%s)
        exp2=$(((d1 - d2) / 86400))
        if [[ $exp2 == "0" ]]; then
                sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/vlesswstls.json
                sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/vlessgrpc.json
        fi
done
systemctl restart xray@vlesswstls
systemctl restart xray@vlessgrpc

# Trojan
data=($(cat /usr/local/etc/xray/trojanwstls.json | grep '^###' | cut -d ' ' -f 2))
now=$(date +"%Y-%m-%d")
for user in "${data[@]}"; do
        exp=$(grep -w "^### $user" "/usr/local/etc/xray/trojanwstls.json" | cut -d ' ' -f 3)
        d1=$(date -d "$exp" +%s)
        d2=$(date -d "$now" +%s)
        exp2=$(((d1 - d2) / 86400))
        if [[ $exp2 == "0" ]]; then
                sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/trojanwstls.json
                sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/trojangrpc.json
                sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/trojanwscf.json
        fi
done
systemctl restart xray@trojanwstls
systemctl restart xray@trojangrpc
systemctl restart xray@trojanwscf
