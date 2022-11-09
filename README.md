# K8S Local Elastic Stack 

This repository can be used to parse and display any kubernetes component logs in Elastic Stack on a local kind cluster.
Some examples are also included :
- K8S audit logs
- Traefik logs

## Usage

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

## Audit Logs

- Edit the `audit-policy.yaml` according to your needs.

NOTE: The `kind-config.yaml` specify an extraMounts to make the audit config file avalailable into the kind docker container.

- Follow the steps in "Usage" section

Documentation links for K8S Audit logs:

- https://kubernetes.io/docs/tasks/debug-application-cluster/audit/
- https://kind.sigs.k8s.io/docs/user/auditing/

## Traefik logs

cf. [TRAEFIK_LOGS.md](./TRAEFIK_LOGS.md)

## Clean

```bash
kind delete cluster
```
