#!/bin/bash
if [ "${EUID}" -ne 0 ]; then
        echo "Harap Menggunakan User ROOT"
        exit 1
fi
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(curl -4 -k -sS ip.sb)
# Hapus (Avoid Duplicate)
rm -f /etc/fuby
rm -f /etc/fuby/vmess
rm -f /root/akun/vmess
rm -f /root/akun/vless
rm -f /root/akun/trojan
rm -f /root/akun/shadowsocks
# Buat Folder
mkdir /etc/fuby
mkdir /etc/fuby/vmess
mkdir -p /root/akun/vmess
mkdir -p /root/akun/vless
mkdir -p /root/akun/trojan
mkdir -p /root/akun/shadowsocks
mkdir -p /root/akun/shadowsocksblake
touch /root/domain
echo "Tolong masukan domain yang sudah dipointing agar v2ray service work"
read -p "Hostname / Domain: " host
echo "$host" >>/etc/fuby/domain
echo "$host" >>/root/domain

# Link Environment
source="https://raw.githubusercontent.com/moonsinnn/easy-install/refs/heads/main/addons"
scgeo="https://raw.githubusercontent.com/malikshi/v2ray-rules-dat/release"
domain=$(cat /root/domain)

# Install Paket
echo
echo -n 'Instalasi Paket.....'
apt -y install wget curl jq shc screenfetch >/dev/null 2>&1
echo '.....Selesai'

# Set Timezone GMT +7
echo
echo -n 'Set Zona Waktu GMT +7.....'
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime >/dev/null 2>&1
echo '.....Selesai'

# Accept Env
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config >/dev/null 2>&1

# Edit file /etc/systemd/system/rc-local.service
cat >/etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat >/etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
# echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
# sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# Fix Missing
echo
echo -n 'Fix Paket Hilang.....'
apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof >/dev/null 2>&1
echo '.....Telah DiFix'
#echo "clear" >> .profile
#echo "welcome" >> .profile

# Install Nginx
echo
echo -n 'Instalasi Nginx.....'
apt -y install curl tar socat wget >/dev/null 2>&1
apt -y install nginx >/dev/null 2>&1
echo '.....Nginx Dikonfigurasi'
cd
rm /etc/nginx/sites-enabled/default >/dev/null 2>&1
rm /etc/nginx/sites-available/default >/dev/null 2>&1
wget -q -O /etc/nginx/conf.d/netz.conf "${source}/netz.conf"
systemctl start nginx >/dev/null 2>&1

# Install Cleanup
echo
echo -n 'Persiapan Install XRAY CORE.....'
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y >/dev/null 2>&1
apt install socat cron bash-completion ntpdate -y >/dev/null 2>&1
ntpdate pool.ntp.org >/dev/null 2>&1
apt -y install chrony >/dev/null 2>&1
timedatectl set-ntp true >/dev/null 2>&1
systemctl enable chronyd && systemctl restart chronyd >/dev/null 2>&1
systemctl enable chrony && systemctl restart chrony >/dev/null 2>&1
timedatectl set-timezone Asia/Jakarta >/dev/null 2>&1
chronyc sourcestats -v >/dev/null 2>&1
chronyc tracking -v >/dev/null 2>&1
date
echo '.....XRAY CORE DITEMUKAN'

# Install Xray Core
echo
echo -n 'Menginstall XRAY CORE.....'
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --beta
echo '.....Terinstall Versi Terbaru'

# Disable Apache2 Server
systemctl stop apache2 >/dev/null 2>&1
systemctl disable apache2 >/dev/null 2>&1
apt remove apache2 -y >/dev/null 2>&1

# Install Certificate
curl https://get.acme.sh | sh
ufw disable >/dev/null 2>&1
systemctl stop nginx
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --register-account -m netz@$domain
~/.acme.sh/acme.sh --issue -d $domain --standalone --server letsencrypt
~/.acme.sh/acme.sh --installcert -d $domain --key-file /etc/fuby/fuby.key --fullchain-file /etc/fuby/fuby.crt

# setup xray config
bash -c "$(curl -s -L https://raw.githubusercontent.com/moonsinnn/easy-install/refs/heads/main/xray.sh)"

systemctl daemon-reload
systemctl restart nginx
systemctl restart xray
echo '.....Selesai'
# Setup Eligabled
systemctl enable xray@vmesswstls >/dev/null 2>&1
systemctl enable xray@vmesswsnontls >/dev/null 2>&1
systemctl enable xray@vmessgrpc >/dev/null 2>&1
systemctl enable xray@vlesswstls >/dev/null 2>&1
systemctl enable xray@vlessgrpc >/dev/null 2>&1
systemctl enable xray@trojanwstls >/dev/null 2>&1
systemctl enable xray@trojangrpc >/dev/null 2>&1
systemctl enable xray@trojanwscf >/dev/null 2>&1
systemctl enable xray@shadowsocksws >/dev/null 2>&1
systemctl enable xray@shadowsocksgrpc >/dev/null 2>&1
systemctl enable xray@ssblakews >/dev/null 2>&1
systemctl enable xray@ssblakegrpc >/dev/null 2>&1
# Restart Eligabled
systemctl restart xray@vmesswstls >/dev/null 2>&1
systemctl restart xray@vmesswsnontls >/dev/null 2>&1
systemctl restart xray@vmessgrpc >/dev/null 2>&1
systemctl restart xray@vlesswstls >/dev/null 2>&1
systemctl restart xray@vlessgrpc >/dev/null 2>&1
systemctl restart xray@trojanwstls >/dev/null 2>&1
systemctl restart xray@trojangrpc >/dev/null 2>&1
systemctl restart xray@trojanwscf >/dev/null 2>&1
systemctl restart xray@shadowsocksws >/dev/null 2>&1
systemctl restart xray@shadowsocksgrpc >/dev/null 2>&1
systemctl restart xray@ssblakews >/dev/null 2>&1
systemctl restart xray@ssblakegrpc >/dev/null 2>&1
# Download Geodata
cd /usr/local/share/xray
rm -rf geosite.dat
rm -rf geoip.dat
wget -q -O geosite.dat "${scgeo}/geosite.dat"
wget -q -O geoip.dat "${scgeo}/geoip.dat"
cd
# Get Traffic Config
cd /etc/fuby
rm -f traffic.conf
wget -q -O traffic.conf "${source}/traffic.conf"
cd
# Get HTML
cd /var/www/html
rm -f index.html
wget -q -O html.zip "${source}/html.zip"
unzip -qq html.zip
rm -f html.zip
cd
# Define an array of script names
scripts=(
        "add-vmess"
        "add-vless"
        "add-trojan"
        "add-ss"
        "add-ssblake"
        "jual-vmess"
        "jual-vless"
        "jual-trojan"
        "cek-vmess"
        "cek-vless"
        "cek-trojan"
        "cek-ss"
        "cek-ssblake"
        "del-vmess"
        "del-vless"
        "del-trojan"
        "del-ss"
        "del-ssblake"
        "renew-vmess"
        "renew-vless"
        "renew-trojan"
        "renew-ss"
        "renew-ssblake"
        "menu"
        "tweak"
        "restart"
        "xp"
        "clear-log"
        "cut-log"
        "welcome"
        "customkernel"
        "badvpn-udpgw"
        "speedtest"
        "menutraffic"
        "certfix"
        "netz-statistik"
        "traffic-vmessnontls"
        "traffic-vmesswstls"
        "traffic-vmessgrpc"
        "traffic-vlesswstls"
        "traffic-vlessgrpc"
        "traffic-trojanwstls"
        "traffic-trojangrpc"
        "traffic-trojanwscf"
        "traffic-shadowsocksws"
        "traffic-shadowsocksgrpc"
        "traffic-ssblakews"
        "traffic-ssblakegrpc"
)

# Get Files
cd /usr/bin
for script in "${scripts[@]}"; do
        wget -q -O "$script" "${source}/$script.sh"
done

# Fix Screenfetch
# rm -f screenfetch
# wget -q -O screenfetch "${source}/screenfetch.sh"

# Set Permission
echo
echo -n 'Set Permission.....'
for script in "${scripts[@]}"; do
        chmod +x "$script"
done
echo '.....Done'

# Killler Cleanup

cd
mv /root/domain /etc/fuby/domain
# Aktivasi UDPGW & Cloudflare Warp+
echo
echo -n 'Instalasi WARP & UDPGW.....'
bash <(curl -L git.io/warp.sh) s5 >/dev/null 2>&1
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
echo '.....Telah Aktif'
# Install VNSTAT
echo
echo -n 'Instalasi Vnstats Monitor.....'
apt -y install vnstat >/dev/null 2>&1
apt -y install vnstati >/dev/null 2>&1
echo '.....Sukses'
# Cleaning
rm -rf ~/.bash_history
history -c && history -w
# Crontab
#echo "0 5 * * * root clear-log && reboot" >> /etc/crontab
#echo "0 0 * * * root xp" >> /etc/crontab
#echo "*/5 * * * * root netz-statistik" >> /etc/crontab
sleep 2 && rm -rf setup.sh && rm -rf xray.sh && rm -rf /tmp/setup.sh
#echo Reboot dalam 3 detik
#eboot
# Logic Installer
history -c
cekprofile=$(cat /etc/profile | grep HISTFILE)
cekprofiletrue="$?"
if [[ $cekprofiletrue == "1" ]]; then
        echo "unset HISTFILE" >>/etc/profile
        echo "0 5 * * * root clear-log && reboot" >>/etc/crontab
        echo "0 0 * * * root xp" >>/etc/crontab
        echo "*/5 * * * * root netz-statistik" >>/etc/crontab
        echo "*/10 * * * * root cut-log" >>/etc/crontab
        echo "clear" >>.profile
        echo "welcome" >>.profile
        echo -e "Rebooting Now"
else
        echo -e "Rebooting Now"
fi
reboot
