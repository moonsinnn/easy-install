#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
clear
# Initialize Restore
# Nama
echo -e "Masukan Nama Yang Telah Tersimpan"
read -rp "Masukan Nama : " -e NamaMu
if [[ -z $NamaMu ]]; then
exit 0
fi
# Pass
echo -e "Masukan Password Yang Telah Tersimpan"
read -rp "Masukan Password : " -e PassKamu
if [[ -z $PassKamu ]]; then
exit 0
fi
# Tanggal
echo -e "Masukan Tanggal Tersimpan"
read -rp "Masukan Tanggal : " -e TanggalMu
if [[ -z $TanggalMu ]]; then
exit 0
fi
echo -e "Processing... "

# Logical Test File
NETZ_UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
HEADER="--header X-Forwarded-For:$XIP"

# Write code
result=$(curl $HEADER --user-agent "${NETZ_UA}" -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://raw.githubusercontent.com/adisubagja/netz-backup/master/$TanggalMu/$NamaMu-$TanggalMu.zip")
if [ "$result" = "404" ]; then
echo -e "${red}Data kamu tidak ada di Netz-Backup${NC}"
exit 0
elif [ "$result" = "200" ]; then
echo -e "${green}Data Kamu Tersedia Di Netz-Backup${NC}"
fi

# Link
cd /root
get_link=https://raw.githubusercontent.com/adisubagja/netz-backup/master/$TanggalMu/$NamaMu-$TanggalMu.zip
wget -q $get_link
cekpassword=$(unzip -qq -t -P $PassKamu /root/$NamaMu-$TanggalMu.zip)
passresult="$?"
if [[ $passresult = "1" ]]; then
echo -e "${red}Password Kamu Salah !!!${NC}"
rm -rf /root/$NamaMu-$TanggalMu.zip
exit 0
elif [[ $passresult = "0" ]]; then
unzip -qq -P $PassKamu /root/$NamaMu-$TanggalMu.zip -d /root
fi
# COPYING FILES
cp /root/backup/xray/* /usr/local/etc/xray

# CLEARING
rm -rf /root/$NamaMu-$TanggalMu.zip
rm -rf /root/backup

# Restart Service
sleep 1
systemctl restart xray@vmesswstls
sleep 1
systemctl restart xray@vmesswsnontls
sleep 1
systemctl restart xray@vmessgrpc
sleep 1
systemctl restart xray@vlesswstls
sleep 1
systemctl restart xray@vlessgrpc
sleep 1
systemctl restart xray@trojanwstls
sleep 1
systemctl restart xray@trojangrpc
sleep 1
systemctl restart xray@shadowsocksws
sleep 1
systemctl restart xray@shadowsocksgrpc

# Pesan
echo -e "Data Telah Dipulihkan
================================
User    : $NamaMu
Pass    : $PassKamu
Tgl     : $TanggalMu
================================
