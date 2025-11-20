#!/bin/bash

# ---------------------------------------------
# User Onboarding Automation Script
# 
# ---------------------------------------------

LOGFILE="user_onboarding.log"

# Function: Print log
log() {
    echo "$(date +"%F %T") : $1" | tee -a "$LOGFILE"
}

# Function: Add user
add_user() {
    read -p "Enter username to create: " username
    
    # Check if user exists
    if id "$username" &>/dev/null; then
        log "Error: User '$username' already exists."
        return
    fi

    # Create user with home directory
    sudo useradd -m "$username"
    log "User '$username' created."

    # Set password
    echo "Set password for $username:"
    sudo passwd "$username"

    # Set expiry date
    read -p "Enter account expiry date (YYYY-MM-DD): " expiry
    sudo chage -E "$expiry" "$username"
    log "Expiry date set: $expiry"

    # Add SSH key
    read -p "Paste SSH public key for user: " sshkey
    
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
