#!/bin/bash

# Update package lists
sudo apt-get update

# Install necessary packages
sudo apt-get install -y wget

# Download Nessus BYOL package
wget https://www.tenable.com/downloads/api/v2/pages/nessus/files/Nessus-10.7.1-ubuntu1804_aarch64.deb

# Install required dependencies for Nessus
sudo apt-get install -y libssl1.0.0 libuuid1 libxml2

# Install Nessus package
sudo dpkg -i Nessus-10.7.1-ubuntu1804_aarch64.deb

#Link Nessus BYOL scanner to Tenable Vulnerability Management
curl -H 'X-Key: 1dbb14c0bfcdb7913d7d891003cc2034b41b279007e20b744de68de6aea49e04' 'https://sensor.cloud.tenable.com/install/scanner?name=PriusOnPrem&groups=PriusGroup' | bash

# Start Nessus service
sudo systemctl start nessusd

# Enable Nessus service to start on boot
sudo systemctl enable nessusd


