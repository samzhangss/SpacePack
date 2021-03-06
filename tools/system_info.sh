#!/usr/bin/env bash
#
#   ██████  ██▓███   ▄▄▄       ▄████▄  ▓█████  ██▓███   ▄▄▄       ▄████▄   ██ ▄█▀       ██████  ██░ ██ 
# ▒██    ▒ ▓██░  ██▒▒████▄    ▒██▀ ▀█  ▓█   ▀ ▓██░  ██▒▒████▄    ▒██▀ ▀█   ██▄█▒      ▒██    ▒ ▓██░ ██▒
# ░ ▓██▄   ▓██░ ██▓▒▒██  ▀█▄  ▒▓█    ▄ ▒███   ▓██░ ██▓▒▒██  ▀█▄  ▒▓█    ▄ ▓███▄░      ░ ▓██▄   ▒██▀▀██░
#   ▒   ██▒▒██▄█▓▒ ▒░██▄▄▄▄██ ▒▓▓▄ ▄██▒▒▓█  ▄ ▒██▄█▓▒ ▒░██▄▄▄▄██ ▒▓▓▄ ▄██▒▓██ █▄        ▒   ██▒░▓█ ░██ 
# ▒██████▒▒▒██▒ ░  ░ ▓█   ▓██▒▒ ▓███▀ ░░▒████▒▒██▒ ░  ░ ▓█   ▓██▒▒ ▓███▀ ░▒██▒ █▄ ██▓ ▒██████▒▒░▓█▒░██▓
# ▒ ▒▓▒ ▒ ░▒▓▒░ ░  ░ ▒▒   ▓▒█░░ ░▒ ▒  ░░░ ▒░ ░▒▓▒░ ░  ░ ▒▒   ▓▒█░░ ░▒ ▒  ░▒ ▒▒ ▓▒ ▒▓▒ ▒ ▒▓▒ ▒ ░ ▒ ░░▒░▒
# ░ ░▒  ░ ░░▒ ░       ▒   ▒▒ ░  ░  ▒    ░ ░  ░░▒ ░       ▒   ▒▒ ░  ░  ▒   ░ ░▒ ▒░ ░▒  ░ ░▒  ░ ░ ▒ ░▒░ ░
# ░  ░  ░  ░░         ░   ▒   ░           ░   ░░         ░   ▒   ░        ░ ░░ ░  ░   ░  ░  ░   ░  ░░ ░
#       ░                 ░  ░░ ░         ░  ░               ░  ░░ ░      ░  ░     ░        ░   ░  ░  ░
#                            ░                                  ░                 ░                    
# Filename:     system_info.sh
# Description:  System Info tool for SpacePack
# Author:       Vtrois <seaton@vtrois.com>
# Project URL:  https://spacepack.sh
# Github URL:   https://github.com/Vtrois/SpacePack
# License:      GPLv3

RGB_WARNING='💡 \033[33;1m'
RGB_DANGER='\033[31m'
RGB_INFO='\033[36m'
RGB_END='\033[0m'

tool_info() {
    echo -e "==========================================================================================="
    echo -e "                             System Info tool for SpacePack                                "
    echo -e "                  For more information please visit https://spacepack.sh                   "
    echo -e "==========================================================================================="
}

operation_system() {
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

public_ip() {
    local IP=$( wget -qO- -t1 -T2 ipv4.icanhazip.com )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipinfo.io/ip)
    [ ! -z "${IP}" ] && echo ${IP} || echo -e "${RGB_DANGER}Unknown${RGB_END}"
}

tencent_cloud() {
    PUBLICIP=$( wget -qO- -t1 -T2 metadata.tencentyun.com/latest/meta-data/public-ipv4 )
    LOCALIP=$( wget -qO- -t1 -T2 metadata.tencentyun.com/latest/meta-data/local-ipv4 )
    MACADDRESS=$( wget -qO- -t1 -T2 metadata.tencentyun.com/latest/meta-data/mac )
    INSTANCEID=$( wget -qO- -t1 -T2 metadata.tencentyun.com/latest/meta-data/instance-id )
    UUID=$( wget -qO- -t1 -T2 metadata.tencentyun.com/latest/meta-data/uuid )
    REGIONZONE=$( wget -qO- -t1 -T2 metadata.tencentyun.com/latest/meta-data/placement/zone )
}

MEMTOTAL=$( cat /proc/meminfo | grep "MemTotal" | awk -F" " '{total=$2/1000}{printf("%d MB",total)}' )
MEMFREE=$( cat /proc/meminfo | grep "MemFree" | awk -F" " '{free=$2/1000}{printf("%d MB",free)}' )
SWAPTOTAL=$( cat /proc/meminfo  | grep "SwapTotal" | awk -F" " '{total=$2/1000}{printf("%d MB",total)}' )
SWAPFREE=$( cat /proc/meminfo  | grep "SwapFree" | awk -F" " '{free=$2/1000}{printf("%d MB",free)}' )
CPUMODEL=$( cat /proc/cpuinfo | grep "model name" | awk 'END{print}' | awk -F": " '{print $2}' )
CPUMHZ=$( cat /proc/cpuinfo | grep "cpu MHz" | awk 'END{print}' | awk -F": " '{print($2,"MHz")}' )
CPUCORES=$( cat /proc/cpuinfo | awk -F: '/model name/ {core++} END {print core}' )
CPUCACHE=$( cat /proc/cpuinfo | grep "cache size" | awk 'END{print}' | awk -F": " '{print $2}' )
SYSOS=$( operation_system )
SYSRISC=$( uname -m )
SYSLBIT=$( getconf LONG_BIT )
KERNEVERSIONL=$( cat /proc/version | awk -F" " '{print $3}' )
NAMESERVER=$( cat /etc/resolv.conf | awk '/^nameserver/{print $2}' | awk 'BEGIN{FS="\n";RS="";ORS=""}{for(x=1;x<=NF;x++){print $x"\t"} print "\n"}' )
TENCENTCLOUD=$( wget -qO- -t1 -T2 metadata.tencentyun.com )
if [ ! -z "${TENCENTCLOUD}" ]; then
tencent_cloud
else
PUBLICIP=$( public_ip )
LOCALIP=$( ifconfig | grep "inet" | grep -v "127.0" | xargs | awk -F '[ :]' '{print $2}' )
MACADDRESS=$( ifconfig | grep "ether" | awk -F" " '{print $2}' )
fi

clear
tool_info
echo -e "\n${RGB_WARNING}Hardware Overview (Contains the System, CPU and Memory)${RGB_END}"
echo -e "${RGB_INFO}Operation System       ${RGB_END}: ${SYSOS}"
echo -e "${RGB_INFO}Hardware Types         ${RGB_END}: ${SYSRISC} (${SYSLBIT} Bit)"
echo -e "${RGB_INFO}Kernel Version         ${RGB_END}: ${KERNEVERSIONL}"
echo -e "${RGB_INFO}CPU model              ${RGB_END}: ${CPUMODEL}"
echo -e "${RGB_INFO}CPU Cores              ${RGB_END}: ${CPUCORES}"
echo -e "${RGB_INFO}CPU Cache Size         ${RGB_END}: ${CPUCACHE}"
echo -e "${RGB_INFO}CPU Basic Frequency    ${RGB_END}: ${CPUMHZ}"
echo -e "${RGB_INFO}Total amount of Memory ${RGB_END}: ${MEMTOTAL} (${MEMFREE} Free)"
echo -e "${RGB_INFO}Total amount of Swap   ${RGB_END}: ${SWAPTOTAL} (${SWAPFREE} Free)"
echo -e "\n${RGB_WARNING}Network Overview (Contains the DNS and IP address (public and internal))${RGB_END}"
echo -e "${RGB_INFO}Public IP              ${RGB_END}: ${PUBLICIP}"
echo -e "${RGB_INFO}Local IP               ${RGB_END}: ${LOCALIP}"
echo -e "${RGB_INFO}MAC Address            ${RGB_END}: ${MACADDRESS}"
echo -e "${RGB_INFO}Nameserver             ${RGB_END}: ${NAMESERVER}"
if [ ! -z "${TENCENTCLOUD}" ]; then
echo -e "\n${RGB_WARNING}Tencent Cloud Overview (Contains the UUID, Instance ID and Zone)${RGB_END}"
echo -e "${RGB_INFO}Instance ID            ${RGB_END}: ${INSTANCEID}"
echo -e "${RGB_INFO}UUID                   ${RGB_END}: ${UUID}"
echo -e "${RGB_INFO}Region & Zone          ${RGB_END}: ${REGIONZONE}"
fi