#!/bin/bash
# Define color codes
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
# Check for root user
if [ "${EUID}" -ne 0 ]; then
        echo -e "Please run as ${red}ROOT${NC} user. !!"
        exit 1
fi
# Get public IP
MYIP=$(curl -4 -k -sS ip.sb)

# Clean up previous configurations
rm -rf /etc/fuby /root/akun/*

# Create necessary directories
mkdir -p /etc/fuby/vmess /root/akun/{vmess,vless,trojan}
touch /root/domain

# Prompt for domain input
echo -e "${green}Please enter the domain that has been pointed for v2ray service to work:${NC}"
read -p "Hostname / Domain: " host
echo "$host" | tee /etc/fuby/domain /root/domain >/dev/null

# Define source URLs
source="https://raw.githubusercontent.com/moonsinnn/easy-install/refs/heads/main/addons"
scgeo="https://raw.githubusercontent.com/malikshi/v2ray-rules-dat/release"
domain=$(cat /root/domain)

# Check and install missing packages
for pkg in bsdmainutils coreutils; do
        if ! dpkg -l | grep -q "$pkg"; then
                echo -e "${green}Installing $pkg...${NC}"
                apt install "$pkg" -y >/dev/null 2>&1
        else
                echo -e "${green}$pkg is already installed.${NC}"
        fi
done
# Install necessary packages
echo -e "${green}Installing packages...${NC}"
apt -y install wget curl jq shc screenfetch >/dev/null 2>&1 && echo -e "${green}Installation complete.${NC}"

# Set timezone to GMT +7
echo -e "${green}Setting timezone to GMT +7...${NC}"
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime >/dev/null 2>&1 && echo -e "${green}Timezone set.${NC}"

# Modify SSH configuration
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config >/dev/null 2>&1

# Create rc-local service
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

# Create rc.local file
cat >/etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Check if rc.local was created successfully
if [ -f /etc/rc.local ]; then
        # Set permissions for rc.local
        chmod +x /etc/rc.local
else
        echo -e "${red}Failed to create /etc/rc.local.${NC}"
        exit 1
fi

# Enable and start rc-local service
systemctl enable rc-local
systemctl start rc-local.service
# Fix missing packages
echo -e "${green}Fixing missing packages...${NC}"
apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip >/dev/null 2>&1 && echo -e "${green}Packages fixed.${NC}"

# Install Nginx
echo -e "${green}Installing Nginx...${NC}"
apt -y install nginx >/dev/null 2>&1 && echo -e "${green}Nginx installed and configured.${NC}"

# Clean up default Nginx configuration
rm -f /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default
wget -q -O /etc/nginx/conf.d/fuby.conf "${source}/fuby.conf"
systemctl start nginx >/dev/null 2>&1

# Install XRAY Core
echo -e "${green}Preparing to install XRAY CORE...${NC}"
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --beta && echo -e "${green}XRAY CORE installed successfully.${NC}"

# Disable Apache2 server if running
systemctl stop apache2 >/dev/null 2>&1
systemctl disable apache2 >/dev/null 2>&1
apt remove apache2 -y >/dev/null 2>&1

# Install SSL certificate
curl https://get.acme.sh | sh
ufw disable >/dev/null 2>&1
systemctl stop nginx
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --register-account -m netz@$domain
~/.acme.sh/acme.sh --issue -d $domain --standalone --server letsencrypt
~/.acme.sh/acme.sh --installcert -d $domain --key-file /etc/fuby/fuby.key --fullchain-file /etc/fuby/fuby.crt

# Setup XRAY configuration
echo -e "${green}Preparing to install XRAY config...${NC}"
bash -c "$(curl -s -L https://raw.githubusercontent.com/moonsinnn/easy-install/refs/heads/main/xray.sh)" && echo -e "${green}XRAY config installed successfully.${NC}"

# Restart services
systemctl daemon-reload
systemctl restart nginx
systemctl restart xray
echo -e "${green}Services restarted successfully.${NC}"

# Enable XRAY services
for service in vmesswstls vmesswsnontls vmessgrpc vlesswstls vlessgrpc trojanwstls trojangrpc trojanwscf; do
        systemctl enable xray@"$service" >/dev/null 2>&1
        systemctl restart xray@"$service" >/dev/null 2>&1
done

# Download geodata
cd /usr/local/share/xray
rm -rf geosite.dat geoip.dat
wget -q -O geosite.dat "${scgeo}/geosite.dat"
wget -q -O geoip.dat "${scgeo}/geoip.dat"

# Get traffic configuration
cd /etc/fuby
rm -f traffic.conf
wget -q -O traffic.conf "${source}/traffic.conf"

# Get HTML files
cd /var/www/html
rm -f index.html
wget -q -O html.zip "${source}/html.zip"
unzip -qq html.zip
rm -f html.zip

# Define an array of script names
scripts=(
        "add-vmess" "add-vless" "add-trojan"
        "jual-vmess" "jual-vless" "jual-trojan" "cek-vmess" "cek-vless"
        "cek-trojan" "del-vmess" "del-vless"
        "del-trojan" "renew-vmess" "renew-vless"
        "renew-trojan" "menu" "tweak"
        "restart" "xp" "clear-log" "cut-log" "welcome"
        "customkernel" "badvpn-udpgw" "speedtest" "menutraffic"
        "certfix" "stats-info" "traffic-vmessnontls" "traffic-vmesswstls"
        "traffic-vmessgrpc" "traffic-vlesswstls" "traffic-vlessgrpc"
        "traffic-trojanwstls" "traffic-trojangrpc" "traffic-trojanwscf"
)

# Download scripts
cd /usr/bin
for script in "${scripts[@]}"; do
        wget -q -O "$script" "${source}/$script.sh"
done

# Set permissions for scripts
echo -e "${green}Setting permissions for scripts...${NC}"
for script in "${scripts[@]}"; do
        chmod +x "$script"
done
echo -e "${green}Permissions set successfully.${NC}"

# Cleanup
cd
mv /root/domain /etc/fuby/domain

# Install WARP & UDPGW
echo -e "${green}Installing WARP & UDPGW...${NC}"
bash <(curl -L git.io/warp.sh) s5 >/dev/null 2>&1
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
echo -e "${green}WARP & UDPGW activated.${NC}"

# Install VNSTAT
echo -e "${green}Installing VNSTAT Monitor...${NC}"
apt -y install vnstat vnstati >/dev/null 2>&1 && echo -e "${green}VNSTAT installed successfully.${NC}"

# Clear history
rm -rf ~/.bash_history
history -c && history -w

# Logic Installer
history -c
if ! grep -q "HISTFILE" /etc/profile; then
        echo "unset HISTFILE" >>/etc/profile
        echo "0 5 * * * root clear-log && reboot" >>/etc/crontab
        echo "0 0 * * * root xp" >>/etc/crontab
        echo "*/5 * * * * root stats-info" >>/etc/crontab
        echo "*/10 * * * * root cut-log" >>/etc/crontab
        echo "clear" >>.profile
        echo "welcome" >>.profile
        echo -e "${green}Rebooting Now...${NC}"
else
        echo -e "${green}Rebooting Now...${NC}"
fi
sleep 5
reboot
