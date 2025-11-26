#!/bin/bash

k3d cluster create --port 8080:80@loadbalancer

kubectl create namespace argocd
kubectl create namespace dev
