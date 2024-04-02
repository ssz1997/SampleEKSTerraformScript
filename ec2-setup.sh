#!/usr/bin/env bash

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa

sudo yum install -y wget
wget https://get.helm.sh/helm-v3.6.0-linux-amd64.tar.gz
tar -xzf helm-v3.6.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/
rm -rf helm-v3.6.0-linux-amd64.tar.gz linux-amd64

sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod 755 kubectl
sudo mv kubectl /usr/local/bin/

sudo yum install -y docker
sudo usermod -a -G docker ec2-user
newgrp docker
sudo systemctl enable docker.service
sudo systemctl start docker.service

# aws configure
