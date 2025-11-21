#!/bin/bash

#---------------------------------------------
# User Onboarding Automation Script
#---------------------------------------------

LOGFILE="user_onboarding.log"

log() {
    echo "$(date +"%F %T") : $1" | tee -a "$LOGFILE"
}

add_user() {
    read -p "Enter username to create: " username

    # Validate username
    if [[ -z "$username" ]]; then
        log "Error: Username cannot be empty!"
        exit 1
    fi

    # Check if user exists
    if id "$username" &>/dev/null; then
        log "Error: User '$username' already exists."
        exit 1
    fi

    # Create user
    if ! sudo useradd -m "$username"; then
        log "Error: Failed to create user."
        exit 1
    fi
    log "User '$username' created."

    # Set password
    echo "Set password for $username:"
    if ! sudo passwd "$username"; then
        log "Error: Failed to set password."
        exit 1
    fi

    # Expiry date
    read -p "Enter account expiry date (YYYY-MM-DD): " expiry
    if ! date -d "$expiry" &>/dev/null; then
        log "Error: Invalid expiry date!"
        exit 1
    fi

    if ! sudo chage -E "$expiry" "$username"; then
        log "Error: Failed to set expiry date!"
        exit 1
    fi
    log "Expiry date set: $expiry"

    # SSH Key
    read -p "Paste SSH public key for user: " sshkey
    if [[ ! "$sshkey" =~ ^ssh-(rsa|ed25519) ]]; then
        log "Error: Invalid SSH key! Must start with ssh-rsa or ssh-ed25519."
        exit 1
    fi

    sudo mkdir -p /home/$username/.ssh
    echo "$sshkey" | sudo tee /home/$username/.ssh/authorized_keys > /dev/null

    sudo chmod 600 /home/$username/.ssh/authorized_keys
    sudo chmod 700 /home/$username/.ssh
    sudo chown -R $username:$username /home/$username/.ssh

    log "SSH key added for $username."
    log "User '$username' onboarding completed."

    echo "User onboarding completed successfully!"
}

add_user

