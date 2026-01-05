# helm_create_chart_by_name

## Function Call:

```bash
helm_create_chart_by_name
```

## Description

Creates a new Helm chart with default directory structure, Run this function inside the directory where you want the new chart folder to be created. Will output the chart directory with the default structure.

## Actual call

```bash
helm create EmailApp
```

## output text

```
Creating EmailApp  
```

## Output files

./helm_create_chart_by_name/EmailApp/*

.
├── Chart.yaml
├── charts
├── templates
│   ├── _helpers.tpl
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── httproute.yaml
│   ├── ingress.yaml
│   ├── NOTES.txt
│   ├── service.yaml
│   ├── serviceaccount.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml

## Files help

.
├── Chart.yaml (The main configuration file for the chart.)
├── charts (A directory containing any charts upon which this chart depends.)
├── templates (A directory of templates that, when combined with values, will generate valid Kubernetes manifest files.)
│   ├── _helpers.tpl (Template helpers file, where you can define re-usable snippets.)
│   ├── deployment.yaml (The file describing the Deployment object.)
│   ├── hpa.yaml (The file describing the HorizontalPodAutoscaler object for scaling your pod.)
│   ├── httproute.yaml (The file defining the Gateway API HTTPRoute for routing traffic.)
│   ├── ingress.yaml (The file defining the Ingress object for external access.)
│   ├── NOTES.txt (A plain text file containing short usage notes to be displayed after installation.)
│   ├── service.yaml (The file describing the Service object for internal access.)
│   ├── serviceaccount.yaml (The file describing the ServiceAccount object.)
│   └── tests (Directory containing test files.)
│       └── test-connection.yaml (A default test file to verify the connection.)
└── values.yaml (The default configuration values for this chart.)