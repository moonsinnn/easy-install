#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
clear
echo -e ""
echo -e "======================================"
echo -e ""
echo -e ""
echo -e "    [1] Statistik VMESS WS NONTLS"
echo -e "    [2] Statistik VMESS WS TLS"
echo -e "    [3] Statistik VMESS GRPC"
echo -e "    [4] Statistik VLESS WS TLS"
echo -e "    [5] Statistik VLESS GRPC"
echo -e "    [6] Statistik TROJAN WS TLS"
echo -e "    [7] Statistik TROJAN GRPC"
echo -e "    [8] Statistik TROJAN WS CF"
echo -e "    [x] Exit"
echo -e ""
read -p "    Select From Options [1-12 or x] :  " Menutraffic
echo -e ""
echo -e "======================================"
sleep 1
clear
case $Menutraffic in
1)
        clear
        traffic-vmessnontls
        ;;
2)
        clear
        traffic-vmesswstls
        ;;
3)
        clear
        traffic-vmessgrpc
        ;;
4)
        clear
        traffic-vlesswstls
        ;;
5)
        clear
        traffic-vlessgrpc
        ;;
6)
        clear
        traffic-trojanwstls
        ;;
7)
        clear
        traffic-trojangrpc
        ;;
8)
        clear
        traffic-trojanwscf
        ;;
x)
        exit
        ;;
*)
        echo "Pilih nomor perintah"
        ;;
esac
