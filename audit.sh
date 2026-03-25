#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
NC="\e[0m"

if [[ "$EUID" -ne 0 ]]; then
	echo -e "${RED}[ERROR]${NC} This script must be run as root"
	exit 1
fi

source modules/ssh.sh
source modules/users.sh
source modules/firewall.sh

echo
echo -e "\e[33m┌───────────────────────┐\e[0m"
echo -e "\e[33m│ Linux Hardening Audit │\e[0m"
echo -e "\e[33m└───────────────────────┘\e[0m"
echo

option=$1

case $option in
	ssh)		
		check_ssh_enabled
		check_permit_root_login
		check_password_auth
		check_pubkey_auth
		check_empty_pass
		check_auth_tries
		check_ssh_port
		check_ssh_listen_addr
		;;
	users)
		check_zero_uid
		check_empty_passwords
		check_password_policy
		check_sudo_privileges
		check_home_dirs
		;;
	firewall)
		check_firewall_status
		check_input_policy
		;;
	all)
                check_ssh_enabled
                check_permit_root_login
                check_password_auth
                check_pubkey_auth
                check_empty_pass
                check_auth_tries
                check_ssh_port
                check_ssh_listen_addr
                check_zero_uid
                check_empty_passwords
                check_password_policy
                check_sudo_privileges
                check_home_dirs
                check_firewall_status
                check_input_policy
		;;

	*)
		echo -e "\e[34mUsage:\e[0m   ./audit.sh \e[36m<module>\e[0m"
		echo -e "\e[34mModules:\e[0m \e[36mssh, users, firewall, all\e[0m"
		;;
esac

