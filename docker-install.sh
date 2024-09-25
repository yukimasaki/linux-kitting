#!/bin/bash

sudo apt update -y
sudo apt install -y \
  ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt install docker-ce docker-ce-cli containerd.io -y
sudo apt install docker-compose-plugin -y
sudo usermod -aG docker $USER
sudo systemctl restart docker
echo "Please login again to complete the Docker installation."
exit 0