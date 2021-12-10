#!/bin/bash
# 
# Author : Nikhil Ranjan Nayak
# Web: https://github.com/nikhilnayak98/sand
# Email: Nikhil-Ranjan.Nayak@warwick.ac.uk
# Description: Automation of host firewall rules deployment.


# Internal WWW
if [ "$HOSTNAME" = "Int-WWW" ]
then
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo "Deploy Int-WWW host firewall rules from hostrules.sh"
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

    iptables -P OUTPUT DROP
    iptables -P INPUT DROP
    iptables -A INPUT -p tcp --match multiport --dports 80,443,389 -j ACCEPT
    iptables -A OUTPUT -p tcp --match multiport --sports 80,443,389 -m state --state ESTABLISHED -j ACCEPT
    # For LDAP Access, because Internal DMZ uses services in the Restricted Zone.
    # For DNS
    iptables -A OUTPUT -p tcp --match multiport --dports 389,53 -j ACCEPT
    iptables -A INPUT -p tcp --match multiport --sports 389,53 -m state --state ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -p udp --match multiport --dports 389,53 -j ACCEPT
    iptables -A INPUT -p udp --match multiport --sports 389,53 -m state --state ESTABLISHED -j ACCEPT
    # For ssh from Management Zone
    iptables -A INPUT -s 172.19.0.0/24 -p tcp --dport 22 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
    iptables -A INPUT -s 172.19.0.0/24 -p udp --dport 22 -j ACCEPT
    iptables -A OUTPUT -p udp --sport 22 -m state --state ESTABLISHED -j ACCEPT

# Internal DNS
elif [ "$HOSTNAME" = "Int-DNS" ]
then
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo "Deploy Int-DNS host firewall rules from hostrules.sh"
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

    iptables -P OUTPUT DROP
    iptables -P INPUT DROP
    iptables -A INPUT -p tcp --dport 53 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 53 -m state --state ESTABLISHED -j ACCEPT
    iptables -A INPUT -p udp --dport 53 -j ACCEPT
    iptables -A OUTPUT -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT
    # For ssh from Management Zone
    iptables -A INPUT -s 172.19.0.0/24 -p tcp --dport 22 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
    iptables -A INPUT -s 172.19.0.0/24 -p udp --dport 22 -j ACCEPT
    iptables -A OUTPUT -p udp --sport 22 -m state --state ESTABLISHED -j ACCEPT

# Staff machines and volunteer machines (Regex Citation: https://unix.stackexchange.com/questions/617666/bash-match-regexes-for-both-different-hostnames)
elif [[ "$HOSTNAME" =~ ^Staff-[[:digit:]]$ ]] || [[ "$HOSTNAME" =~ ^Volunteer-[[:digit:]]$ ]]
then
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    if [[ "$HOSTNAME" =~ ^Staff-[[:digit:]]$ ]]
    then
        echo ">>>Deploy ${HOSTNAME} host firewall rules from hostrules.sh"
    elif [[ "$HOSTNAME" =~ ^Volunteer-[[:digit:]]$ ]]
    then
        echo "Deploy ${HOSTNAME} host firewall rules from hostrules.sh"
    fi
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    
    iptables -P OUTPUT DROP
    iptables -P INPUT DROP
    iptables -A OUTPUT -p tcp --match multiport --dports 80,443,25,53,587,993,3128,3129 -j ACCEPT
    iptables -A INPUT -p tcp --match multiport --sports 80,443,25,53,587,993,3128,3129 -m state --state ESTABLISHED -j ACCEPT
    # For ssh from Management Zone
    iptables -A INPUT -s 172.19.0.0/24 -p tcp --dport 22 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
    iptables -A INPUT -s 172.19.0.0/24 -p udp --dport 22 -j ACCEPT
    iptables -A OUTPUT -p udp --sport 22 -m state --state ESTABLISHED -j ACCEPT
    # For DNS udp
    iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
    iptables -A INPUT -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT

# LDAP
elif [ "$HOSTNAME" = "LDAP" ]
then
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo ">>>Deploy LDAP host firewall rules from hostrules.sh"
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

    iptables -P OUTPUT DROP
    iptables -P INPUT DROP

    iptables -A INPUT -p tcp --dport 389 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 389 -m state --state ESTABLISHED -j ACCEPT
    iptables -A INPUT -p udp --dport 389 -j ACCEPT
    iptables -A OUTPUT -p udp --sport 389 -m state --state ESTABLISHED -j ACCEPT
    # For DNS
    iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
    iptables -A INPUT -p tcp --sport 53 -m state --state ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
    iptables -A INPUT -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT
    # For ssh from Management Zone
    iptables -A INPUT -s 172.19.0.0/24 -p tcp --dport 22 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
    iptables -A INPUT -s 172.19.0.0/24 -p udp --dport 22 -j ACCEPT
    iptables -A OUTPUT -p udp --sport 22 -m state --state ESTABLISHED -j ACCEPT

# Database
elif [ "$HOSTNAME" = "Database" ]
then
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo ">>>Deploy Database host firewall rules from hostrules.sh"
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

    iptables -P OUTPUT DROP
    iptables -P INPUT DROP

    iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 3306 -m state --state ESTABLISHED -j ACCEPT
    # For DNS
    iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
    iptables -A INPUT -p tcp --sport 53 -m state --state ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
    iptables -A INPUT -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT
    # For ssh from Management Zone
    iptables -A INPUT -s 172.19.0.0/24 -p tcp --dport 22 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
    iptables -A INPUT -s 172.19.0.0/24 -p udp --dport 22 -j ACCEPT
    iptables -A OUTPUT -p udp --sport 22 -m state --state ESTABLISHED -j ACCEPT

# Mail Server
elif [ "$HOSTNAME" = "Mail" ]
then
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo ">>>Deploy Mail host firewall rules from hostrules.sh"
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    
    iptables -P OUTPUT DROP
    iptables -P INPUT DROP
    iptables -A INPUT -p tcp --match multiport --dports 25,587,993 -j ACCEPT
    iptables -A OUTPUT -p tcp --match multiport --sports 25,587,993 -m state --state ESTABLISHED -j ACCEPT
    # For ssh from Management Zone
    iptables -A INPUT -s 172.19.0.0/24 -p tcp --dport 22 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
    iptables -A INPUT -s 172.19.0.0/24 -p udp --dport 22 -j ACCEPT
    iptables -A OUTPUT -p udp --sport 22 -m state --state ESTABLISHED -j ACCEPT
    # For DNS
    iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
    iptables -A INPUT -p tcp --sport 53 -m state --state ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
    iptables -A INPUT -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT

# Squid Proxy
elif [ "$HOSTNAME" = "Squid" ]
then
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo ">>>Deploy Squid Proxy host firewall rules from hostrules.sh"
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

    iptables -P OUTPUT DROP
    iptables -P INPUT DROP
    iptables -A INPUT -p tcp --match multiport --dports 3128,3129 -j ACCEPT
    iptables -A OUTPUT -p tcp --match multiport --sports 3128,3129 -m state --state ESTABLISHED -j ACCEPT
    # For commlink with internet (KINDA CONFUSING)
    iptables -A OUTPUT -p tcp --match multiport --dports 80,443 -j ACCEPT
    iptables -A INPUT -p tcp --match multiport --sports 80,443 -m state --state ESTABLISHED -j ACCEPT
    # For ssh from Management Zone
    iptables -A INPUT -s 172.19.0.0/24 -p tcp --dport 22 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
    iptables -A INPUT -s 172.19.0.0/24 -p udp --dport 22 -j ACCEPT
    iptables -A OUTPUT -p udp --sport 22 -m state --state ESTABLISHED -j ACCEPT
    # For DNS
    iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
    iptables -A INPUT -p tcp --sport 53 -m state --state ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
    iptables -A INPUT -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT

# External DMZ Web Server
elif [ "$HOSTNAME" = "ExtDMZ-WWW" ]
then
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo ">>>Deploy ExtDMZ-WWW host firewall rules from hostrules.sh"
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

    iptables -P OUTPUT DROP
    iptables -P INPUT DROP
    iptables -A INPUT -p tcp --match multiport --dports 80,443 -j ACCEPT
    iptables -A OUTPUT -p tcp --match multiport --sports 80,443 -m state --state ESTABLISHED -j ACCEPT
    # For ssh from Management Zone
    iptables -A INPUT -s 172.19.0.0/24 -p tcp --dport 22 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
    iptables -A INPUT -s 172.19.0.0/24 -p udp --dport 22 -j ACCEPT
    iptables -A OUTPUT -p udp --sport 22 -m state --state ESTABLISHED -j ACCEPT
    # For DNS
    iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
    iptables -A INPUT -p tcp --sport 53 -m state --state ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
    iptables -A INPUT -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT

# OpenVPN
elif [ "$HOSTNAME" = "OpenVPN" ]
then
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo ">>>Deploy OpenVPN host firewall rules from hostrules.sh"
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    
    iptables -P OUTPUT DROP
    iptables -P FORWARD DROP
    iptables -P INPUT DROP

    # Treat OpenVPN as a gateway firewall
    # When OpenVPN start
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    iptables -t nat -A POSTROUTING -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j SNAT --to 135.207.157.200
    iptables -A FORWARD -s 10.8.0.0/24 -j ACCEPT
    iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT

    # When OpenVPN stops
    #iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
    #iptables -t nat -D POSTROUTING -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j SNAT --to 135.207.157.200
    #iptables -D FORWARD -s 10.8.0.0/24 -j ACCEPT
    #iptables -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT

    # For OpenVPN specific communication
    iptables -A INPUT -p udp --dport 1194 -j ACCEPT
    iptables -A OUTPUT -p udp --sport 1194 -m state --state ESTABLISHED -j ACCEPT
    # For commlink with internet (KINDA CONFUSING)
    iptables -A OUTPUT -p tcp --match multiport --dports 80,443 -j ACCEPT
    iptables -A INPUT -p tcp --match multiport --sports 80,443 -m state --state ESTABLISHED -j ACCEPT
    # For ssh from Management Zone
    iptables -A INPUT -s 172.19.0.0/24 -p tcp --dport 22 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
    iptables -A INPUT -s 172.19.0.0/24 -p udp --dport 22 -j ACCEPT
    iptables -A OUTPUT -p udp --sport 22 -m state --state ESTABLISHED -j ACCEPT
    # For DNS
    iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
    iptables -A INPUT -p tcp --sport 53 -m state --state ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
    iptables -A INPUT -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT

# Admin
elif [ "$HOSTNAME" = "Admin" ]
then
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo "Deploy Admin host firewall rules from hostrules.sh"
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    
    iptables -P OUTPUT DROP
    iptables -P INPUT DROP
    iptables -A OUTPUT -p tcp --match multiport --dports 80,443,25,53,587,993,3128,3129 -j ACCEPT
    iptables -A INPUT -p tcp --match multiport --sports 80,443,25,53,587,993,3128,3129 -m state --state ESTABLISHED -j ACCEPT
    # Allow outgoing ssh only. Block incoming ssh.
    iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
    iptables -A INPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -p udp --dport 22 -j ACCEPT
    iptables -A INPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
    # For DNS udp
    iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
    iptables -A INPUT -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT
fi
