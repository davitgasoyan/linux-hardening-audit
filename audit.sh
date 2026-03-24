#!/bin/bash

source modules/ssh.sh

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
	test)
		echo "hello world"
		;;
	*)
		echo "Usage: ./audit.sh <module>"
		echo "Modules: ssh, test"
		;;
esac

