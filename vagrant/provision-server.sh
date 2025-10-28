#!/usr/bin/env bash
#make the script strict
set -euo pipefail

SERVER_IP="${1:-192.168.56.110}"

sudo apt-get update -y
sudo apt-get install -y curl ca-certificates

# Installe K3s en mode serveur (controller).
# --write-kubeconfig-mode 644 -> kubeconfig lisible par vagrant
# --node-ip pour annoncer la bonne IP 
curl -sfL https://get.k3s.io | sudo INSTALL_K3S_EXEC="--write-kubeconfig-mode 644 --node-ip ${SERVER_IP}" sh -

# Attendre que le token existe
for i in {1..30}; do
  if [ -f /var/lib/rancher/k3s/server/node-token ]; then break; fi
  sleep 2
done

# expose token/kubeconfig fichier partager
# faire attention a l'exposition du token en prod
sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/node-token
sudo cp /etc/rancher/k3s/k3s.yaml /vagrant/kubeconfig.yaml
# Remplace 127.0.0.1 par SERVER IP dans le kubeconfig
sudo sed -i "s/127.0.0.1/${SERVER_IP}/g" /vagrant/kubeconfig.yaml

echo "K3s server OK. Kubeconfig disponible dans /vagrant/kubeconfig.yaml"
echo "TOKEN dans /vagrant/node-token"
