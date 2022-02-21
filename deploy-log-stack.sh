#!/usr/bin/env bash

# Deploy an Elastic Stack

# Init helm repo
helm repo add elastic https://helm.elastic.co
helm repo update

# Timeout for installation
TIMEOUT=300s

# Deploy Elatics (only 1 replica for 1 node kind cluster)
helm upgrade -n logging --create-namespace --wait --timeout=${TIMEOUT} --install elasticsearch elastic/elasticsearch --set replicas=1

# Deploy Filebeat
helm upgrade -n logging --create-namespace --wait --timeout=${TIMEOUT} --install filebeat elastic/filebeat -f values-filebeat.yaml 

# Deploy Logstash
helm upgrade -n logging --create-namespace --wait --timeout=${TIMEOUT} --install logstash elastic/logstash -f values-logstash-beat.yaml

# Deploy Kibana (quite long...)
helm upgrade -n logging --create-namespace --wait --timeout=${TIMEOUT} --install kibana elastic/kibana

# Wait for all pods to be running
echo "Waiting for all pods to be ready..."
kubectl -n logging wait --for=condition=ready pod --all