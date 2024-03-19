#!/bin/bash

curl --request GET \
  --url 'https://www.tenable.com/downloads/api/v2/pages/nessus/files/Nessus-10.7.1-amzn2.x86_64.rpm' \
  --output 'Nessus-10.7.1-amzn2.x86_64.rpm'
sudo rpm -ivh Nessus-10.7.1-amzn2.x86_64.rpm
sudo /sbin/service nessusd start

# After EC2 is up and running, access the Tenable scanner on http://ec2-public-ip:8834