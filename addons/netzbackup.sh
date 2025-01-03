#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
clear
# Initialize Backup
# Tanggal
Tanggal=$(date +"%Y-%m-%d")
# Nama
echo -e "Buatlah Nama Anda Sendiri"
read -rp "Masukan Nama : " -e NamaMu
if [[ -z $NamaMu ]]; then
exit 0
fi
echo -e "Buatlah Password Rahasia Sendiri"
read -rp "Masukan Password : " -e PassKamu
if [[ -z $PassKamu ]]; then
exit 0
fi
echo -e "Processing... "

# Logical Checker
# Logical Test File
NETZ_UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
HEADER="--header X-Forwarded-For:$XIP"

# Write code
result=$(curl $HEADER --user-agent "${NETZ_UA}" -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://raw.githubusercontent.com/adisubagja/netz-backup/master/$Tanggal/$NamaMu-$Tanggal.zip")
if [ "$result" = "200" ]; then
echo -e "${red}Data Telah Ada Gunakan Nama Lain${NC}"
exit 0
elif [ "$result" = "404" ]; then
echo -e "${green}SIP Data Kamu Akan Dibackup${NC}"
fi


mkdir -p /root/backup

# Link Backup
cp -r /usr/local/etc/xray /root/backup
cd /root
zip -rP $PassKamu $NamaMu-$Tanggal.zip backup > /dev/null 2>&1


# Initialize Github
git config --global user.email "adisubagja.id@gmail.com" &> /dev/null
git config --global user.name "Assisten-Netz" &> /dev/null
git clone https://github.com/adisubagja/netz-backup adi-assistance &> /dev/null
mkdir /root/adi-assistance/$Tanggal &> /dev/null
mv /root/$NamaMu-$Tanggal.zip /root/adi-assistance/$Tanggal/$NamaMu-$Tanggal.zip &> /dev/null
cd adi-assistance &> /dev/null
git pull &> /dev/null
git add . &> /dev/null
git commit -m "$NamaMu-$Tanggal Sukses Dibackup" &> /dev/null
git push -f https://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@github.com/adisubagja/netz-backup.git &> /dev/null

# CLEARING
rm -rf /root/backup
rm -rf /root/adi-assistance
rm -rf /root/$NamaMu-$Tanggal.zip
echo -e "Data Telah Tersimpan Di Netz-Backup
================================
User    : $NamaMu
Pass    : $PassKamu
Tgl     : $Tanggal
================================
Silahkan catat atau simpan data tersebut baik-baik
Untuk Restore Tinggal Masukan Nama Tanggal dan Password saja
