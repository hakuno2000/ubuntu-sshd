# Use an official Ubuntu base image
FROM ubuntu:24.04

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV SSH_USERNAME="root"
ENV SSHD_CONFIG_ADDITIONAL=""

# Install OpenSSH server, clean up, create directories, set permissions, and configure SSH
RUN apt-get update \
    && apt-get install -y iproute2 iputils-ping openssh-server telnet \
    && apt-get install -y nano curl git cron build-essential protobuf-compiler pkg-config libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir -p /run/sshd \
    && chmod 755 /run/sshd \
    && mkdir -p /"$SSH_USERNAME"/.ssh \
    && chown "$SSH_USERNAME":"$SSH_USERNAME" /"$SSH_USERNAME"/.ssh \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# Copy the script to configure the user's password and authorized keys
COPY configure-ssh-user.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/configure-ssh-user.sh

# Expose SSH port
EXPOSE 22

COPY setup-voting.sh /root
RUN chmod +x /root/setup-voting.sh

# Start SSH server
CMD ["bash", "-c", "/usr/local/bin/configure-ssh-user.sh && /root/setup-voting.sh"]
