#!/bin/bash

check_permit_root_login() {
	local config="/etc/ssh/sshd_config"
	if grep -qE '^PermitRootLogin\s+yes' "$config"; then
		echo "[WARNING] PermitRootLogin is enabled"
	else
		echo "[INFO] PermitRootLogin is disabled"
	fi
}

check_pubkey_auth() {
	local config="/etc/ssh/sshd_config"
	if grep -qE '^PubkeyAuthentication\s+yes' "$config"; then
		echo "[WARNING] PubkeyAuthentication is enabled"
	else
		echo "[INFO] PubkeyAuthentication is disabled"
	fi
}
check_permit_root_login
check_pubkey_auth
