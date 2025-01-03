#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
clear
echo -n >/tmp/other.txt
data=($(cat /usr/local/etc/xray/trojanwstls.json | grep '^###' | cut -d ' ' -f 2))
echo "-------------------------------"
echo "-----=[ Trojan User Login ]=-----"
echo "-------------------------------"
for akun in "${data[@]}"; do
        if [[ -z $akun ]]; then
                akun="tidakada"
        fi
        echo -n >/tmp/iptrojan.txt
        data2=($(netstat -anp | grep ESTABLISHED | grep tcp | grep nginx | awk '{print $5}' | cut -d: -f1 | grep -v 127.0.0.1 | sort | uniq))
        for ip in "${data2[@]}"; do
                jum=$(cat /var/log/xray/access3.log | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | grep -v 127.0.0.1 | sort | uniq)
                if [[ $jum == "$ip" ]]; then
                        echo "$jum" >>/tmp/iptrojan.txt
                else
                        echo "$ip" >>/tmp/other.txt
                fi
                jum2=$(cat /tmp/iptrojan.txt)
                sed -i "/$jum2/d" /tmp/other.txt >/dev/null 2>&1
        done
        jum=$(cat /tmp/iptrojan.txt)
        if [[ -z $jum ]]; then
                echo >/dev/null
        else
                jum2=$(cat /tmp/iptrojan.txt | nl)
                echo "user : $akun"
                echo "$jum2"
                echo "-------------------------------"
        fi
        rm -rf /tmp/iptrojan.txt
done
oth=$(cat /tmp/other.txt | sort | uniq | nl)
echo "other"
echo "$oth"
echo "-------------------------------"
