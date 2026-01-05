# helm_install_chart_by_ns_by_release_by_chart

## Function Call:

```bash
helm_install_chart_by_ns_by_release_by_chart default my-nginx bitnami/nginx
```

## Description

Installs a Helm chart

## Actual call

```bash
helm install my-nginx bitnami/nginx -n default
```

## output:

```
NAME: my-nginx
LAST DEPLOYED: Fri Jan  4 14:26:35 2026
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: nginx
CHART VERSION: 18.3.5
APP VERSION: 1.27.3

** Please be patient while the chart is being deployed **
NGINX can be accessed through the following DNS name from within your cluster:

    my-nginx.default.svc.cluster.local (port 80)

To access NGINX from outside the cluster, follow the steps below:

1. Get the URL of the NGINX application:

  echo "URL: http://127.0.0.1:8080/"
  kubectl port-forward --namespace default svc/my-nginx 8080:80

... (warnings about rolling tags and resources omitted for brevity)
```
