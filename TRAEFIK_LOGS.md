# Traefik Logs

This repository can also be used to parse and display any kubernetes component logs in the Elastic Stack.
Here is an example to collect Traefik access logs.

## Setup

To view Traefik access logs, you must deploy filebeat with the corresponding configuration:

- `values-filebeat-traefik-accesslog-file.yaml`: filebeat uses the simple `log` input to read traefik access log
- `values-filebeat-traefik-accesslog-module.yaml`: filebeat uses the `treafik` module (does not work with JSON formatted access logs)

WARNING: no logs are visible in Kibana with the 1st config ("file")... do not know why yet.

```bash
helm upgrade -n logging --create-namespace --wait --install filebeat elastic/filebeat -f <YOUR_FILEBEAT_VALUES.yaml>
```

*NOTES*: if you use logstash, the `traefik` module needs additionnal confirguration explained in the `Use a filebeat module` section.

Deploy traefik after updating the `values-traefik.yaml` file according to your requirements:

```bash
./deploy-traefik.sh
```

Access traefik dashboard:

```bash
kubectl port-forward $(kubectl get pod -l app.kubernetes.io/instance=traefik -o name | head -n 1) 9000:9000
```

Open : `http://localhost:9000/dashboard/`

Deploy a sample application with a Traefik IngressRoute:

```bash
kubectl apply -f traefik-samples/whoami.yaml
```

Access application via Traefik service:

```bash
kubectl port-forward $(kubectl -n traefik get svc -l app.kubernetes.io/instance=traefik -o name) -n traefik 8080:80
```

Open : `http://localhost:8080/whoami/`

Generate load:

```bash
while true; do curl http://127.0.0.1:8080/whoami/; sleep 5; clear;  done
```

Open Kibana to see Traefik access logs.

## Use a filebeat module

https://www.elastic.co/guide/en/logstash/8.0/use-ingest-pipelines.html#use-ingest-pipelines

To add a filebeat module when elastic is not directly a filebeat output (in the case filebeat->logstash->elastic), we must do this manually.
Plus, this step needs elastic details to add the modules :

(Execute these commands into the filebeat pod)

```bash
ES_HOST="http://elasticsearch-master:9200"

# In case of an authenticated elastisearch only
# ES_USERNAME="$(kubectl get -n logging secrets/elasticsearch-master-credentials --template={{.data.username}} | base64 -d)"
# ES_PASSWORD="$(kubectl get -n logging secrets/elasticsearch-master-credentials --template={{.data.password}} | base64 -d)"

# Enable module (by default all modules are disabled: cf. `filebeat modules list`)
filebeat modules enable traefik
# Setup corresponding pipeline on ElasticSearch
filebeat setup --pipelines --modules traefik \
    -E output.logstash.enabled=false \
    -E output.elasticsearch.hosts=["${ES_HOST}"]

# In case of an authenticated elastisearch only, add:
    # -E output.elasticsearch.username="${ES_USERNAME}" \
    # -E output.elasticsearch.password="${ES_PASSWORD}"
```
