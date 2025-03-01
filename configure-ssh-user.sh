#!/bin/bash

# Set default values for SSH_USERNAME and SSH_PASSWORD if not provided
: ${SSH_USERNAME:=root}
: ${SSH_PASSWORD:?"Error: SSH_PASSWORD environment variable is not set."}
: ${SSHD_CONFIG_ADDITIONAL:=""}
echo "$SSH_USERNAME:$SSH_PASSWORD" | chpasswd

# Set the authorized keys from the AUTHORIZED_KEYS environment variable (if provided)
if [ -n "$AUTHORIZED_KEYS" ]; then
    mkdir -p /$SSH_USERNAME/.ssh
    echo "$AUTHORIZED_KEYS" > /$SSH_USERNAME/.ssh/authorized_keys
    chown -R $SSH_USERNAME:$SSH_USERNAME /$SSH_USERNAME/.ssh
    chmod 700 /$SSH_USERNAME/.ssh
    chmod 600 /$SSH_USERNAME/.ssh/authorized_keys
    echo "Authorized keys set for user $SSH_USERNAME"
    # Disable password authentication if authorized keys are provided
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
fi

# Apply additional SSHD configuration if provided
if [ -n "$SSHD_CONFIG_ADDITIONAL" ]; then
    echo "$SSHD_CONFIG_ADDITIONAL" >> /etc/ssh/sshd_config
    echo "Additional SSHD configuration applied"
fi

# Apply additional SSHD configuration from a file if provided
if [ -n "$SSHD_CONFIG_FILE" ] && [ -f "$SSHD_CONFIG_FILE" ]; then
    cat "$SSHD_CONFIG_FILE" >> /etc/ssh/sshd_config
    echo "Additional SSHD configuration from file applied"
fi

# Start the SSH server
echo "Starting SSH server..."
exec /usr/sbin/sshd -D
