#!/bin/bash

if [ $(whoami) != root ]; then
    exec sudo bash "$0"
fi

(
  while true; do
    kubectl port-forward svc/argocd-server -n argocd --address 0.0.0.0 8080:443 >/dev/null 2>&1
    sleep 2
  done
) &
