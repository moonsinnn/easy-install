#!/bin/bash
red="\e[1;31m"
green="\e[0;32m"
NC="\e[0m"

# Fetch OS
#neofetch
# Get Information
IPADRESS=$(curl -4 -k -sS ip.sb)
DOMAIN=$(cat /etc/fuby/domain)
SERVER=$(curl -s -4 https://ipapi.co/${IPADRESS}/country_name/)
ISP=$(curl -s -4 https://ipapi.co/${IPADRESS}/org/)
echo -e "-------------------------------------------------------------"
echo -e "IP ADRESS	: ${IPADRESS}"
echo -e "DOMAIN		: ${DOMAIN}"
echo -e "SERVER VPS	: ${SERVER}"
echo -e "ISP		: ${ISP}"
echo -e "-------------------------------------------------------------"

# Vmess WS TLS
status="$(systemctl show xray@vmesswstls --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]; then
        echo -e "Vmess WS TLS	: "$green"Aktif"$NC""
else
        echo -e "Vmess WS TLS	: "$red"Tidak Aktif (Error)"$NC""
fi

# Vmess Non TLS
status="$(systemctl show xray@vmesswsnontls --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]; then
        echo -e "Vmess Non TLS	: "$green"Aktif"$NC""
else
        echo -e "Vmess Non TLS	: "$red"Tidak Aktif (Error)"$NC""
fi

# Vmess GRPC
status="$(systemctl show xray@vmessgrpc --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]; then
        echo -e "Vmess GRPC 	: "$green"Aktif"$NC""
else
        echo -e "Vmess GRPC 	: "$red"Tidak Aktif (Error)"$NC""
fi

# Vless WS TLS
status="$(systemctl show xray@vlesswstls --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]; then
        echo -e "Vless WS TLS 	: "$green"Aktif"$NC""
else
        echo -e "Vless WS TLS 	: "$red"Tidak Aktif (Error)"$NC""
fi

# Vless GRPC
status="$(systemctl show xray@vlessgrpc --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]; then
        echo -e "Vless GRPC 	: "$green"Aktif"$NC""
else
        echo -e "Vless GRPC 	: "$red"Tidak Aktif (Error)"$NC""
fi

# Trojan WS TLS
status="$(systemctl show xray@trojanwstls --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]; then
        echo -e "Trojan WS TLS 	: "$green"Aktif"$NC""
else
        echo -e "Trojan WS TLS 	: "$red"Tidak Aktif (Error)"$NC""
fi

# Trojan GRPC
status="$(systemctl show xray@trojangrpc --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]; then
        echo -e "Trojan GRPC 	: "$green"Aktif"$NC""
else
        echo -e "Trojan GRPC 	: "$red"Tidak Aktif (Error)"$NC""
fi

# Trojan WS CF
status="$(systemctl show xray@trojanwscf --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]; then
        echo -e "Trojan WS CF 	: "$green"Aktif"$NC""
else
        echo -e "Trojan WS CF 	: "$red"Tidak Aktif (Error)"$NC""
fi
# Nginx
status="$(systemctl show nginx --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]; then
        echo -e "Nginx      	: "$green"Aktif"$NC""
else
        echo -e "Nginx      	: "$red"Tidak Aktif (Error)"$NC""
fi
