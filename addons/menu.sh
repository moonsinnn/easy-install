#!/bin/bash

# Define color codes
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'

# Clear the screen
clear

# Function to display system information
display_system_info() {
    echo -e "\n   -------------------------------------------------------------"
    local cname=$(awk -F: '/model name/ {print $2}' /proc/cpuinfo | head -n 1)
    local cores=$(grep -c 'model name' /proc/cpuinfo)
    local freq=$(awk -F: '/cpu MHz/ {print $2}' /proc/cpuinfo | head -n 1)
    local tram=$(free -m | awk 'NR==2 {print $2}')
    local swap=$(free -m | awk 'NR==3 {print $2}')
    local up=$(uptime -p | sed 's/up //')

    # Display formatted output
    echo -e "\n   ${green}CPU Model:${NC} $cname"
    echo -e "   ${green}Number Of Cores:${NC} $cores"
    echo -e "   ${green}CPU Frequency:${NC} $freq MHz"
    echo -e "   ${green}Total Amount Of RAM:${NC} $tram MB"
    echo -e "   ${green}Total Memory:${NC} $swap MB"
    echo -e "   ${green}System Uptime:${NC} $up"
    echo -e "\n   ------------------------- MENU OPTIONS ------------------------\n"
}

# Function to display menu options
display_menu_options() {
    echo -e "   Please select an option from the following menu:\n"
    local options=("add-vmess" "add-vless" "add-trojan" "del-vmess" "del-vless" "del-trojan" "renew-vmess" "renew-vless" "renew-trojan" "cek-vmess" "cek-vless" "cek-trojan" "menutraffic" "tweak" "restart" "certfix")

    for i in "${!options[@]}"; do
        echo -e "   $((i + 1))) ${green}${options[i]}${NC}"
    done
    echo -e "\n   ${red}Note:${NC} You can also press 'x' to exit."
}

# Function to execute user choice
execute_choice() {
    case $1 in
        1) add-vmess ;;
        2) add-vless ;;
        3) add-trojan ;;
        4) del-vmess ;;
        5) del-vless ;;
        6) del-trojan ;;
        7) renew-vmess ;;
        8) renew-vless ;;
        9) renew-trojan ;;
        10) cek-vmess ;;
        11) cek-vless ;;
        12) cek-trojan ;;
        13) menutraffic ;;
        14) tweak ;;
        15) restart ;;
        16) certfix ;;
        x) exit 0 ;;
        *) echo -e "${red}Please select a valid option.${NC}" ;;
    esac
}

# Main script execution
display_system_info
display_menu_options

# Read user input
read -p "     Choose an option [1-16 or x]: " menu
execute_choice "$menu"
