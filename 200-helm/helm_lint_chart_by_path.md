# helm_lint_chart_by_path

## Function Call:

```bash
helm_lint_chart_by_path ./EmailApp
```

## Description

Examines a chart for possible issues, call.

## Actual call

```bash
helm lint ./EmailApp
```

## output:

```
==> Linting /Users/rcarrion/data/r-core/_shell-fun/200-helm/helm_create_chart_by_name/EmailApp
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed
```

## Full output

```
==> Linting /Users/rcarrion/data/r-core/_shell-fun/200-helm/helm_create_chart_by_name/EmailApp
[INFO] Chart.yaml: icon is recommended
[WARNING] templates/deployment.yaml: object name does not conform to Kubernetes naming requirements: "test-release-EmailApp": metadata.name: Invalid value: "test-release-EmailApp": a lowercase RFC 1123 subdomain must consist of lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character (e.g. 'example.com', regex used for validation is '[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*')
[WARNING] templates/service.yaml: object name does not conform to Kubernetes naming requirements: "test-release-EmailApp": metadata.name: Invalid value: "test-release-EmailApp": a DNS-1035 label must consist of lower case alphanumeric characters or '-', start with an alphabetic character, and end with an alphanumeric character (e.g. 'my-name',  or 'abc-123', regex used for validation is '[a-z]([-a-z0-9]*[a-z0-9])?')
[WARNING] templates/serviceaccount.yaml: object name does not conform to Kubernetes naming requirements: "test-release-EmailApp": metadata.name: Invalid value: "test-release-EmailApp": a lowercase RFC 1123 subdomain must consist of lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character (e.g. 'example.com', regex used for validation is '[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*')
[WARNING] templates/tests/test-connection.yaml: object name does not conform to Kubernetes naming requirements: "test-release-EmailApp-test-connection": metadata.name: Invalid value: "test-release-EmailApp-test-connection": a lowercase RFC 1123 subdomain must consist of lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character (e.g. 'example.com', regex used for validation is '[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*')

1 chart(s) linted, 0 chart(s) failed
```

