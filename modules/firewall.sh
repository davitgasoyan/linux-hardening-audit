#!/bin/bash

# Service
check_firewall_status() {
	if [[ "$(systemctl is-active iptables.service)" == "inactive" && "$(systemctl is-active ufw.service)" == "inactive" ]]; then
		echo -e "\e[31m[WARNING]\e[0m Firewall is not running"
	else
		echo -e "\e[32m[INFO]\e[0m Firewall is running"
	fi
}


