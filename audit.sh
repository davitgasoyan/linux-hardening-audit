#!/bin/bash

if [[ "$EUID" -ne 0 ]]; then
	echo -e "\e[31m[ERROR]\e[0m This script must be run as root"
	exit 1
fi

source modules/ssh.sh
source modules/users.sh

echo
echo "┌───────────────────────┐"
echo "│ Linux Hardening Audit │"
echo "└───────────────────────┘"
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
		;;
	*)
		echo "Usage: ./audit.sh <module>"
		echo "Modules: ssh, users"
		;;
esac

