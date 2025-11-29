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

k3d cluster create fbessonS -p "8080:80@loadbalancer"

kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait --for=condition=Ready -n argocd --all pod --timeout=300s
kubectl port-forward svc/argocd-server -n argocd 8081:443 &
disown
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 --decode
echo " "

neofetch
if command -v figlet &>/dev/null; then
    figlet "K3D NODE"
else
    echo "K3D NODE"
fi
