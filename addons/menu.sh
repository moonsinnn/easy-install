#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
echo -e ""
echo -e "   -------------------------------------------------------------"
cname=$(awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo)
cores=$(awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo)
freq=$(awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo)
tram=$(free -m | awk 'NR==2 {print $2}')
swap=$(free df | awk 'NR==2 {print $2}')
up=$(uptime | awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')
echo -e ""
echo -e "   \e[032;1mCPU Model:\e[0m $cname"
echo -e "   \e[032;1mNumber Of Cores:\e[0m $cores"
echo -e "   \e[032;1mCPU Frequency:\e[0m $freq MHz"
echo -e "   \e[032;1mTotal Amount Of RAM:\e[0m $tram MB"
echo -e "   \e[032;1mTotal Memory :\e[0m $swap MB"
echo -e "   \e[032;1mSystem Uptime:\e[0m $up Hours"
echo -e ""
echo -e "   -------------------------PILIHAN MENU------------------------"
echo -e ""
echo -e "   1\e[1;33m)\e[m Membuat Akun Vmess"
echo -e "   2\e[1;33m)\e[m Membuat Akun Vless"
echo -e "   3\e[1;33m)\e[m Membuat Akun Trojan"
echo -e "   4\e[1;33m)\e[m Membuat Akun Shadowsocks"
echo -e "   5\e[1;33m)\e[m Membuat Akun Shadowsocks 2022"
echo -e "   6\e[1;33m)\e[m Hapus Akun Vmess"
echo -e "   7\e[1;33m)\e[m Hapus Akun Vless"
echo -e "   8\e[1;33m)\e[m Hapus Akun Trojan"
echo -e "   9\e[1;33m)\e[m Hapus Akun Shadowsocks"
echo -e "   10\e[1;33m)\e[m Hapus Akun Shadowsocks 2022"
echo -e "   11\e[1;33m)\e[m Perpanjang Vmess"
echo -e "   12\e[1;33m)\e[m Perpanjang Vless"
echo -e "   13\e[1;33m)\e[m Perpanjang Trojan"
echo -e "   14\e[1;33m)\e[m Perpanjang Shadowsocks"
echo -e "   15\e[1;33m)\e[m Perpanjang Shadowsocks 2022"
echo -e "   16\e[1;33m)\e[m Cek Vmess"
echo -e "   17\e[1;33m)\e[m Cek Vless"
echo -e "   18\e[1;33m)\e[m Cek Trojan"
echo -e "   19\e[1;33m)\e[m Cek Shadowsocks"
echo -e "   20\e[1;33m)\e[m Cek Shadowsocks 2022"
echo -e "   21\e[1;33m)\e[m Menu Traffic"
echo -e "   22\e[1;33m)\e[m Kernel Update + TweakBBR"
echo -e "   23\e[1;33m)\e[m Memuat Ulang Xray Service"
echo -e "   24\e[1;33m)\e[m Ganti Domain & Certfix"
#echo -e "   25\e[1;33m)\e[m Backup Akun Ke Netz-Backup"
#echo -e "   26\e[1;33m)\e[m Restore Akun Dari Netz-Backup"
#echo -e "   27\e[1;33m)\e[m Custom Kernel Powered By XANMOD"
read -p "     Pilih Satu Opsi [1-27 atau x] :  " menu
case $menu in
1)
        add-vmess
        ;;
2)
        add-vless
        ;;
3)
        add-trojan
        ;;
4)
        add-ss
        ;;
5)
        add-ssblake
        ;;
6)
        del-vmess
        ;;
7)
        del-vless
        ;;
8)
        del-trojan
        ;;
9)
        del-ss
        ;;
10)
        del-ssblake
        ;;
11)
        renew-vmess
        ;;
12)
        renew-vless
        ;;
13)
        renew-trojan
        ;;
14)
        renew-ss
        ;;
15)
        renew-ss
        ;;
16)
        cek-vmess
        ;;
17)
        cek-vless
        ;;
18)
        cek-trojan
        ;;
19)
        cek-ss
        ;;
20)
        cek-ss
        ;;
21)
        menutraffic
        ;;
22)
        tweak
        ;;
23)
        restart
        ;;
24)
        certfix
        ;;
25)
        netzbackup
        ;;
26)
        netzrestore
        ;;
27)
        customkernel
        ;;
x)
        welcome
        ;;
*)
        echo "Pilih nomor perintah"
        ;;
esac
