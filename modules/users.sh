#!/bin/bash

# UID-0
check_zero_uid() {
	local users
	users=$(awk -F: '$1!="root" && $3==0 {print $1}' /etc/passwd)
	if [[ -n "$users" ]]; then
		echo -e "\e[31m[WARNING]\e[0m Non-root user found with 0 UID: ${users}"
	else
		echo -e "\e[32m[INFO]\e[0m Non-root user with 0 UID not found"
	fi
	echo
}

# Empty Password 
check_empty_passwords() {
	local users
	users=$(awk -F: '$2=="" {print $1}' /etc/shadow)
	if [[ -n "$users" ]]; then
	        echo -e "\e[31m[WARNING]\e[0m User with empty password found: ${users}"
        else
                echo -e "\e[32m[INFO]\e[0m User with empty password not found"
        fi
	echo
}

# Pass Max Days
check_password_policy() {
	local days
	days=$(awk '$1=="PASS_MAX_DAYS" {print $2}' /etc/login.defs)
	if [[ $days -ge 90 ]]; then
		echo -e "\e[31m[WARNING]\e[0m Password max days is more than 90 (${days})"
      	else
 		echo -e "\e[32m[INFO]\e[0m Password max days is ${days}"
	fi		
	echo
}

# Sudo privileges
check_sudo_privileges() {
	local users
	local groups
	users=$(grep -rhE 'ALL=\(ALL' /etc/sudoers /etc/sudoers.d/ | grep -v '^[#%]' | grep -vw "root")
	groups=$(grep -rhE 'ALL=\(ALL' /etc/sudoers /etc/sudoers.d/ | grep '^%' | grep -vw "sudo")
	if [[ -n "$users" && -n "$groups" ]]; then
		echo -e "\e[31m[WARNING]\e[0m Users and groups with sudo privileges found:"
		echo -e "$users\n$groups"	
	elif [[ -n "$users" ]]; then
		echo -e "\e[31m[WARNING]\e[0m Users with sudo privileges found:"
		echo -e "$users"
	elif [[ -n "$groups" ]]; then
		echo -e "\e[31m[WARNING]\e[0m Groups with sudo privileges found:"
		echo -e "$groups"
	else
		echo -e "\e[32m[INFO]\e[0m No users and groups with sudo privileges"
	fi	
	echo
}

# Home directories writable
check_home_dirs() {
	dirs=$(ls -l /home | grep -E 'd[rwx-]{6}[r-][w][x-]')
	if [[ -n $dirs ]]; then
		echo -e "\e[31m[WARNING]\e[0m Home directories writable for other users:"
		echo $dirs
	else
		echo -e "\e[32m[INFO]\e[0m No home directories writable for other users"
	fi
	echo
}

