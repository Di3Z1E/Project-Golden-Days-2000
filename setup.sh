#!/bin/bash

# Elevate the script to run as root if not already
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Update and Upgrade the local server
apt update && apt upgrade -y

# Install open-ssh
apt install openssh-server -y

# Uninstall all conflicting packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do apt-get remove -y $pkg; done

# Install Ansible
apt install -y software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt install -y ansible

# Download game servers
docker pull lacledeslan/gamesvr-goldsource-cstrike
docker pull lacledeslan/gamesvr-cssource
docker pull sourceservers/left4dead2
docker pull krustowski/samp-server-docker
