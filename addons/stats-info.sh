#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
clear

# Source Files Configuration
source /etc/fuby/traffic.conf
# Define
VNSTATI="/usr/bin/vnstati"
PATH="/var/www/html/traffic"
FILENAME="vnstat"

if [[ -f "/etc/fuby/traffic.conf" ]]; then
        ### Bandwidth Summary
        ${VNSTATI} -s -i $INTERFACE -o ${PATH}/${FILENAME}-summary.png # Summary for our nic

        # Bandwidth - Top Days
        ${VNSTATI} -m -i $INTERFACE -o ${PATH}/${FILENAME}-top-days.png # Sort top days at top (this will show the days you used most banwidth for your server, sorted by 5)

        # Bandwidth stats for: Realtime/Hourly/Daily/Monthly/Yearly
        ${VNSTATI} -5 -i $INTERFACE -o ${PATH}/${FILENAME}-fiveminutes.png   # Output 5 minutes
        ${VNSTATI} -h -i $INTERFACE -o ${PATH}/${FILENAME}-hourly.png        # Hourly
        ${VNSTATI} -hg -i $INTERFACE -o ${PATH}/${FILENAME}-hourly-graph.png # Hourly Graph
        ${VNSTATI} -d -i $INTERFACE -o ${PATH}/${FILENAME}-daily.png         # Daily
        ${VNSTATI} -m -i $INTERFACE -o ${PATH}/${FILENAME}-monthly.png       # Monthly
        ${VNSTATI} -y -i $INTERFACE -o ${PATH}/${FILENAME}-yearly.png        # Yearly
else
        echo -e "Konfigurasi tidak ada"
fi
