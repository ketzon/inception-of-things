#!/usr/bin/env bash
#strict mode
set -euo pipefail

SERVER_IP="${1:-192.168.56.110}"

sudo apt-get update -y
sudo apt-get install -y curl ca-certificates

# recup token du serv via fichier partager
if [ ! -f /vagrant/node-token ]; then
  echo "no token, wait for server provisionning"
  # wait token 2mn
  for i in {1..24}; do
    [ -f /vagrant/node-token ] && break
    sleep 5
  done
fi
TOKEN="$(cat /vagrant/node-token)"

# Installe K3s en mode worker(agent) et rejoint le cluster a son adresse grace au token
export K3S_URL="https://${SERVER_IP}:6443"
export K3S_TOKEN="${TOKEN}"
curl -sfL https://get.k3s.io | sudo K3S_URL="$K3S_URL" K3S_TOKEN="$K3S_TOKEN" sh -s - agent
echo "K3s worker OK. Rejoint ${K3S_URL}"
