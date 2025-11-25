#!/bin/bash


#update package and install mandatory
apt-get update -y
apt-get install git docker.io curl vim neofetch -y

#install k3d via curl
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# install kubectl
curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
