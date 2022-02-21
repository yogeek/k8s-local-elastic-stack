#!/usr/bin/env bash

# Deploy an Elastic Stack

# Init helm repo
helm repo add traefik https://helm.traefik.io/traefik
helm repo update

# Timeout for installation
TIMEOUT=300s

# Deploy Elatics (only 1 replica for 1 node kind cluster)
helm upgrade -n traefik --create-namespace --wait --timeout=${TIMEOUT} --install traefik traefik/traefik \
  --set logs.access.enabled=true
