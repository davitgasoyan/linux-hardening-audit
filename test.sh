#!/bin/bash

RED="\e[31m"

# Service
check_firewall_status() {
	local services=("ufw" "firewalld" "nftables" "iptables")
	local active=false
	for service in "${services[@]}"; do
		if systemctl is-active --quiet "$service"; then
			echo -e "\e[32m[INFO]\e[0m Firewall is running"
			active=true
			break
		fi
	done
	if [[ "$active" == false ]]; then
		echo -e "${RED}[WARNING]\e[0m Firewall is not running"
	fi
	echo
}

# Input policy
check_input_policy() {
	local policy=$(iptables -L INPUT | head -n 1 | tr -d "()" | awk '{print $4}')
	if [[ "$policy" == ACCEPT ]]; then
		echo -e "${RED}[WARNING]\e[0m Default INPUT policy is ACCEPT"
	else
		echo -e "\e[32m[INFO]\e[0m Default INPUT policy is ${policy}"
	fi
	echo
}


check_input_policy
