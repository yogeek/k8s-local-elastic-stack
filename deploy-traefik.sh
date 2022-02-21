#!/usr/bin/env bash

# Deploy an Elastic Stack

# Init helm repo
helm repo add traefik https://helm.traefik.io/traefik
helm repo update

# Deploy Elatics (only 1 replica for 1 node kind cluster)
# helm upgrade -n traefik --create-namespace -wait --timeout=${TIMEOUT} --install traefik traefik/traefik -f values-traefik.yaml
helm upgrade -n traefik --create-namespace --install traefik traefik/traefik -f values-traefik.yaml

# Exposing Dashboard
# kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name) 9000:9000