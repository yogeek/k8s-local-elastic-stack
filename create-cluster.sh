#!/usr/bin/env bash

kind create cluster --config kind-config.yaml

# Wait for all pods to be running
echo "Waiting for all pods to be ready..."
kubectl wait --for=condition=ready pod --all --all-namespaces