#!/bin/bash

# always run as root
if [ "$(whoami)" != "root" ]; then
    exec sudo bash "$0"
fi

while true; do
    echo "[ArgoCD] starting port-forward 8080 -> 80 ..."
    kubectl port-forward svc/argocd-server -n argocd 8080:80 --address 0.0.0.0 >/dev/null 2>&1
    echo "[ArgoCD] port-forward crashed, restarting in 2 sec..."
    sleep 2
done
