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
./create-cluster.sh
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

## Clean

```bash
kind delete cluster
```
