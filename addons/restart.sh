#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
clear
echo -e ""
echo -e "======================================"
echo -e ""
echo -e ""
echo -e "    [1] Restart All Services"
echo -e "    [2] Restart Vmess"
echo -e "    [3] Restart Vless"
echo -e "    [4] Restart Trojan"
echo -e "    [5] Restart Nginx"
echo -e "    [x] Exit"
echo -e ""
read -p "    Select From Options [1-5 or x] :  " Restart
echo -e ""
echo -e "======================================"
sleep 1
clear
case $Restart in
1)
        clear
        systemctl restart xray@vmesswstls
        systemctl restart xray@vmesswsnontls
        systemctl restart xray@vmessgrpc
        systemctl restart xray@vlesswstls
        systemctl restart xray@vlessgrpc
        systemctl restart xray@trojanwstls
        systemctl restart xray@trojangrpc
        systemctl restart xray@trojanwscf
        systemctl restart nginx
        echo -e ""
        echo -e "======================================"
        echo -e ""
        echo -e "          Service/s Restarted         "
        echo -e ""
        echo -e "======================================"
        exit
        ;;
2)
        clear
        systemctl restart xray@vmesswstls
        systemctl restart xray@vmesswsnontls
        systemctl restart xray@vmessgrpc
        echo -e ""
        echo -e "======================================"
        echo -e ""
        echo -e "          Service/s Restarted         "
        echo -e ""
        echo -e "======================================"
        exit
        ;;
3)
        clear
        systemctl restart xray@vlesswstls
        systemctl restart xray@vlessgrpc
        echo -e ""
        echo -e "======================================"
        echo -e ""
        echo -e "          Service/s Restarted         "
        echo -e ""
        echo -e "======================================"
        exit
        ;;
4)
        clear
        systemctl restart xray@trojanwstls
        systemctl restart xray@trojangrpc
        systemctl restart xray@trojanwscf
        echo -e ""
        echo -e "======================================"
        echo -e ""
        echo -e "          Service/s Restarted         "
        echo -e ""
        echo -e "======================================"
        exit
        ;;
5)
        clear
        systemctl restart nginx
        echo -e ""
        echo -e "======================================"
        echo -e ""
        echo -e "          Service/s Restarted         "
        echo -e ""
        echo -e "======================================"
        exit
        ;;
x)
        exit
        ;;
*)
        echo "Pilih nomor perintah"
        ;;
esac
