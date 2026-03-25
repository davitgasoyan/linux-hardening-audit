#!/bin/bash

# Service
check_ssh_enabled() {
	if [[ $(systemctl is-active ssh) == "active" ]]; then
		echo -e "${RED}[WARNING]${NC} SSH service is running"
	else
		echo -e "${GREEN}[INFO]${NC} SSH service is not running"
	fi
	echo
}

# PermitRootLogin
check_permit_root_login() {
	local config="/etc/ssh/sshd_config"
	if grep -qE '^PermitRootLogin\s+yes' "$config"; then
		echo -e "${RED}[WARNING]${NC} Root login is enabled"
	else
		echo -e "${GREEN}[INFO]${NC} Root login is disabled"
	fi
	echo
}

# PasswordAuthentication
check_password_auth() {
        local config="/etc/ssh/sshd_config"
        if grep -qE '^PasswordAuthentication\s+yes' "$config"; then
                echo -e "${RED}[WARNING]${NC} Password authentication is enabled"
        else
                echo -e "${GREEN}[INFO]${NC} Password authentication is disabled"
        fi
	echo
}

# PubkeyAuthentication
check_pubkey_auth() {
	local config="/etc/ssh/sshd_config"
	if grep -qE '^PubkeyAuthentication\s+yes' "$config"; then
		echo -e "${GREEN}[INFO]${NC} Pubkey authentication is enabled"
	else
		echo -e "${RED}[WARNING]${NC} Pubkey authentication is disabled"
	fi
	echo
}

# PermitEmptyPasswords
check_empty_pass() {
	local config="/etc/ssh/sshd_config"
	if grep -qE '^PermitEmptyPasswords\s+yes' "$config"; then
		echo -e "${RED}[WARNING]${NC} Empty passwords are permitted"
	else
		echo -e "${GREEN}[INFO]${NC} Empty passwords are not permitted"
	fi
	echo
}

# MaxAuthTries
check_auth_tries() {
	local config="/etc/ssh/sshd_config"
	local count
	if grep -qE '^MaxAuthTries\s+[0-9]+' "$config"; then
		count=$(grep -E '^MaxAuthTries\s+[0-9]+' "$config" | awk '{print $2}')
	else
		count=6
	fi
	if [[ "$count" -gt 3 ]]; then
		echo -e "${RED}[WARNING]${NC} Max authentication tries is $count (recommended: ≤ 3)"
	else
		echo -e "${GREEN}[INFO]${NC} Max authentication tries is $count"
	fi
	echo
}

# Port
check_ssh_port() {
        local config="/etc/ssh/sshd_config"
	if grep -E '^Port\s+[0-9]+' "$config" | grep -vwq "22"; then
		local port=$(grep -E '^Port\s+[0-9]+' "$config" | grep -vw "22" | awk '{print $2}')
		echo -e "${GREEN}[INFO]${NC} SSH is listening on port ${port}"
	else
		echo -e "${RED}[WARNING]${NC} SSH is listening on default port (22)"
	fi
	echo
}

# ListenAddress
check_ssh_listen_addr() {
	local config="/etc/ssh/sshd_config"
	local address
	if grep -qE '^ListenAddress\s+[0-9]' "$config"; then
		address=$(grep -E '^ListenAddress\s+[0-9]' "$config" | awk '{print $2}')
		if [[ "$address" != "0.0.0.0" ]]; then
			echo -e "${GREEN}[INFO]${NC} SSH is listening on ipv4 address ${address}"
		else
			echo -e "${RED}[WARNING]${NC} SSH is listening on all ipv4 addresses (0.0.0.0)"
		fi
	else
		echo -e "${RED}[WARNING]${NC} SSH is listening on all ipv4 addresses (0.0.0.0)"
	fi
	echo

}

