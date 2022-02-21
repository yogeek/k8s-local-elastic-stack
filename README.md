# k8s-audit-kind

This repository allows testing K8S audit logs configuration by offering a simple way to visualize these logs with ElasticStack on a kind cluster.

Documentation links:

- https://kubernetes.io/docs/tasks/debug-application-cluster/audit/
- https://kind.sigs.k8s.io/docs/user/auditing/

## Setup

- Edit the `audit-policy.yaml` according to your needs.

NOTE: The `kind-config.yaml` specify an extraMounts to make the audit config file avalailable into the kind docker container.

- Start the cluster

```bash
kind create cluster --config kind-config.yaml
```

- Display audit logs to test

```bash
docker exec kind-control-plane cat /var/log/kubernetes/kube-apiserver-audit.log
```

- Add Elastic Stack

```bash
./deploy-log-stack.sh
```

- Expose Kibana

```bash
kubectl -n logging port-forward svc/kibana-kibana 5601
```

- Access Kibana and configure index

 - Open : http://localhost:5601/app/discover
 - Click on "Create index pattern"
 - Set `filebeat-*` as "Name"
 - Chosse `@timestamp` as "Timestamp field"
 - Click on "Create index pattern"
 - Go on "Discover" page to see audit logs : http://localhost:5601/app/discover


### Add filebeat module

https://www.elastic.co/guide/en/logstash/8.0/use-ingest-pipelines.html#use-ingest-pipelines

To add a filebeat module when elastic is not directly a filebeat output (in the case filebeat->logstash->elastic), we must do this manually.
Plus, this step needs elastic details to add the modules :

ES_HOST="http://elasticsearch-master:9200"
ES_USERNAME="$(kubectl get -n logging secrets/elasticsearch-master-credentials --template={{.data.username}} | base64 -d)"
ES_PASSWORD="$(kubectl get -n logging secrets/elasticsearch-master-credentials --template={{.data.password}} | base64 -d)"

filebeat setup --pipelines --modules traefik \
    -E output.logstash.enabled=false \
    -E output.elasticsearch.hosts=["${ES_HOST}"] \
    -E output.elasticsearch.username="${ES_USERNAME}" \
    -E output.elasticsearch.password="${ES_PASSWORD}"

## Traefik

Deploy traefik after updating the `values-trafik.yaml` file according to your requirements:

```bash
./deploy-trafik.sh
```

Access trafik dashboard:

```bash
kubectl port-forward $(kubectl get pod -l app.kubernetes.io/instance=traefik -o name | head -n 1) 9000:9000
```

Open : `http://localhost:9000/dashboard/`

Deploy a sample application:

```bash
kubectl apply -f trafik/whoami.yaml
```



## Clean

```bash
kind delete cluster
```
