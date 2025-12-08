#!/bin/bash

command -v k3d >/dev/null || { echo "k3d missing"; exit 1; }
command -v kubectl >/dev/null || { echo "kubectl missing"; exit 1; }

#  create cluster
k3d cluster create bonus-cluster -p "8080:80@loadbalancer"

#  setup kubeconfig
mkdir -p /home/vagrant/.kube
k3d kubeconfig get bonus-cluster > /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

#  install ArgoCD 
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait --for=condition=Ready -n argocd pods --timeout=600s

# 5) apply bootstrap 
kubectl apply -n argocd -f /vagrant/bootstrap/root-application.yml

# 6) port forward
nohup kubectl port-forward svc/argocd-server -n argocd 8080:443 --address 0.0.0.0 >/dev/null 2>&1 &

echo " "
echo "ArgoCD admin password:"
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
echo " "

figlet "BONUS READY"
neofetch
