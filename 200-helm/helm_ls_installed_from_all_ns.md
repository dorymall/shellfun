# helm_ls_installed_from_all_ns

## Function Call:

```bash
helm_ls_installed_from_all_ns
```

## Description

Lists all installed releases across all namespaces.

## Actual call

```bash
helm list -A
```

## output:

```
NAME       	NAMESPACE  	REVISION	UPDATED                                	STATUS  	CHART                      	APP VERSION
traefik    	kube-system	1       	2025-11-01 19:16:56.66217961 +0000 UTC 	deployed	traefik-34.2.1+up34.2.0    	v3.3.2     
traefik-crd	kube-system	1       	2025-11-01 19:16:55.536044183 +0000 UTC	deployed	traefik-crd-34.2.1+up34.2.0	v3.3.2     

```