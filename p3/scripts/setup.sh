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


k3d cluster create -p 8080:80@loadbalancer

kubectl create namespace argocd
kubectl create namespace dev

neofetch
if command -v figlet &>/dev/null; then
    figlet "K3D NODE"
else
    echo "K3D NODE"
fi
