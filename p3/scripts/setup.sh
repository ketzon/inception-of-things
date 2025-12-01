#!/bin/bash

check_binary() {
    if ! command -v "$1" &>/dev/null; then
        echo "$1 is not installed on this node"
        exit 1
    else
        echo "$1 is installed"
    fi
}

check_binary k3d
check_binary kubectl

# create cluster
k3d cluster create fbessonS -p "8888:8888@loadbalancer"

# fix kube config
mkdir -p /home/vagrant/.kube
k3d kubeconfig get fbessonS > /home/vagrant/.kube/config
chmod 600 /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# create name space
kubectl create namespace argocd
kubectl create namespace dev

# install argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

#wait
kubectl wait --for=condition=Ready -n argocd --all pod --timeout=300s

# display password
echo "Argocd password: "
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 --decode
echo " "

# argo cd confs
kubectl apply -n argocd -f /vagrant/confs/argocd-cm.yml
kubectl apply -n argocd -f /vagrant/confs/argocd-deploy.yml

#print infos cluster
neofetch
if command -v figlet &>/dev/null; then
    figlet "K3D NODE"
else
    echo "K3D NODE"
fi
