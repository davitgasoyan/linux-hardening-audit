#!/bin/bash

echo
echo "┌───────────────────────┐"
echo "│ Linux Hardening Audit │"
echo "└───────────────────────┘"
echo

# SSH

check_ssh_enabled() {
	if [[ $(systemctl is-active ssh) == "active" ]]; then
		echo -e "\e[31m[WARNING]\e[0m SSH service is running"	
	else
		echo -e "\e[32m[INFO]\e[0m SSH service is not running"
	fi
	echo
}

check_permit_root_login() {
	local config="/etc/ssh/sshd_config"
	if grep -qE '^PermitRootLogin\s+yes' "$config"; then
		echo -e "\e[31m[WARNING]\e[0m Root login is enabled"
	else
		echo -e "\e[32m[INFO]\e[0m Root login is disabled"
	fi
	echo
}

check_password_auth() {
        local config="/etc/ssh/sshd_config"
        if grep -qE '^PasswordAuthentication\s+yes' "$config"; then
                echo -e "\e[31m[WARNING]\e[0m Password authentication is enabled"
        else
                echo -e "\e[32m[INFO]\e[0m Password authentication is disabled"
        fi
	echo
}

check_pubkey_auth() {
	local config="/etc/ssh/sshd_config"
	if grep -qE '^PubkeyAuthentication\s+yes' "$config"; then
		echo -e "\e[32m[INFO]\e[0m Pubkey authentication is enabled"
	else
		echo -e "\e[31m[WARNING]\e[0m Pubkey authentication is disabled"
	fi
	echo
}

check_empty_pass() {
	local config="/etc/ssh/sshd_config"
	if grep -qE '^PermitEmptyPasswords\s+yes' "$config"; then
		echo -e "\e[31m[WARNING]\e[0m Empty passwords are permitted"
	else
		echo -e "\e[32m[INFO]\e[0m Empty passwords are not permitted"
	fi
	echo
}

check_auth_tries() {
	local config="/etc/ssh/sshd_config"
	local count
	if grep -qE '^MaxAuthTries\s+[0-9]+' "$config"; then
		count=$(grep -E '^MaxAuthTries\s+[0-9]+' "$config" | awk '{print $2}')
	else
		count=6
	fi
	if [[ "$count" -gt 3 ]]; then
		echo -e "\e[31m[WARNING]\e[0m Max authentication tries is $count (recommended: ≤ 3)"
	else
		echo -e "\e[32m[INFO]\e[0m Max authentication tries is $count"
	fi
	echo
}

check_ssh_port() {
        local config="/etc/ssh/sshd_config"
	if grep -E '^Port\s+[0-9]+' "$config" | grep -vwq "22"; then
		local port=$(grep -E '^Port\s+[0-9]+' "$config" | grep -vw "22" | awk '{print $2}')
		echo -e "\e[32m[INFO]\e[0m SSH is listening on port ${port}"
	else
		echo -e "\e[31m[WARNING]\e[0m SSH is listening on default port (22)"
	fi
	echo
}

check_ssh_listen_addr() {
	local config="/etc/ssh/sshd_config"
	local address
	if grep -qE '^ListenAddress\s+[0-9]' "$config"; then
		address=$(grep -E '^ListenAddress\s+[0-9]' "$config" | awk '{print $2}')
		if [[ "$address" != "0.0.0.0" ]]; then
			echo -e "\e[32m[INFO]\e[0m SSH is listening on ipv4 address ${address}"
		else
			echo -e "\e[31m[WARNING]\e[0m SSH is listening on all ipv4 addresses (0.0.0.0)"
		fi
	else
		echo -e "\e[31m[WARNING]\e[0m SSH is listening on all ipv4 addresses (0.0.0.0)"
	fi
	echo

}



check_ssh_enabled
check_permit_root_login
check_password_auth
check_pubkey_auth
check_empty_pass
check_auth_tries
check_ssh_port
check_ssh_listen_addr

