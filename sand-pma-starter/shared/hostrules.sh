#!/bin/bash
# 
# Author : Nikhil Ranjan Nayak
# Web: https://github.com/nikhilnayak98/sand
# Email: Nikhil-Ranjan.Nayak@warwick.ac.uk
# Description: Automation of host firewall rules deployment because I am so fucking lazy.
#
# TODO: Add host firewall rules for Admin machines. Remove all stupid comments.

# Internal WWW
if [ "$HOSTNAME" = "Int-WWW" ]
then
    iptables -P OUTPUT DROP
    iptables -P INPUT DROP
    echo "Deploy Int-WWW host firewall rules from hostrules.sh"
    iptables -A INPUT -p tcp --match multiport --dports 80,443,389 -j ACCEPT
    iptables -A OUTPUT -p tcp --match multiport --sports  80,443,389 -m state --state ESTABLISHED -j ACCEPT

# Internal DNS
elif [ "$HOSTNAME" = "Int-DNS" ]
then
    echo "Deploy Int-DNS host firewall rules from hostrules.sh"
    iptables -A INPUT -p tcp --dport 53 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport  53 -m state --state ESTABLISHED -j ACCEPT
    iptables -A INPUT -p udp --dport 53 -j ACCEPT
    iptables -A OUTPUT -p udp --sport  53 -m state --state ESTABLISHED -j ACCEPT

# Staff machines and volunteer machines (Regex Citation: https://unix.stackexchange.com/questions/617666/bash-match-regexes-for-both-different-hostnames)
elif [[ "$HOSTNAME" =~ ^Staff-[[:digit:]]$ ]] || [[ "$HOSTNAME" =~ ^Volunteer-[[:digit:]]$ ]]
then
    iptables -P OUTPUT DROP
    iptables -P INPUT DROP
    iptables -A INPUT -p tcp --match multiport --dports 80,443,22,25,53,587,993,3128,3129 -j ACCEPT
    iptables -A OUTPUT -p tcp --match multiport --sports 80,443,22,25,53,587,993,3128,3129 -m state --state ESTABLISHED -j ACCEPT
    # For DNS
    iptables -A INPUT -p tcp --dport 53 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport  53 -m state --state ESTABLISHED -j ACCEPT
    iptables -A INPUT -p udp --dport 53 -j ACCEPT
    iptables -A OUTPUT -p udp --sport  53 -m state --state ESTABLISHED -j ACCEPT
    if [[ "$HOSTNAME" =~ ^Staff-[[:digit:]]$ ]]
    then
        echo "Deploy ${HOSTNAME} host firewall rules from hostrules.sh"
    elif [[ "$HOSTNAME" =~ ^Volunteer-[[:digit:]]$ ]]
    then
        echo "Deploy ${HOSTNAME} host firewall rules from hostrules.sh"
    fi

# LDAP
elif [ "$HOSTNAME" = "LDAP" ]
then
    echo "Deploy LDAP host firewall rules from hostrules.sh"
    iptables -A INPUT -p tcp --dport 389 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 389 -m state --state ESTABLISHED -j ACCEPT

# Mail Server
elif [ "$HOSTNAME" = "Mail" ]
then
    echo "Deploy Mail host firewall rules from hostrules.sh"
    iptables -A INPUT -p tcp --match multiport --dports 25,587,993 -j ACCEPT
    iptables -A OUTPUT -p tcp --match multiport --sports 25,587,993 -m state --state ESTABLISHED -j ACCEPT

# Squid Proxy
elif [ "$HOSTNAME" = "Squid" ]
then
    echo "Deploy Squid Proxy host firewall rules from hostrules.sh"
    iptables -A INPUT -p tcp --match multiport --dports 80,443,25,3128,3129 -j ACCEPT
    iptables -A OUTPUT -p tcp --match multiport --sports 80,443,25,3128,3129 -m state --state ESTABLISHED -j ACCEPT

# OpenVPN
elif [ "$HOSTNAME" = "OpenVPN" ]
then
    echo "Deploy OpenVPN host firewall rules from hostrules.sh"
    iptables -A INPUT -p tcp --dport 1194 -j ACCEPT
    iptables -A OUTPUT -p tcp --sport 1194 -m state --state ESTABLISHED -j ACCEPT

# Admin
elif [ "$HOSTNAME" = "Admin" ]
then
    echo "Deploy Admin host firewall rules from hostrules.sh"
    
fi