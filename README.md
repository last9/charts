# Last9 Helm Charts

Helm chart repository for [Last9](https://last9.io) observability platform.

## Install

```bash
helm repo add last9 https://last9.github.io/charts
helm repo update
helm search repo last9
```

## Charts

| Chart | Description | Docs |
|---|---|---|
| [`last9-k8s-infra`](charts/last9-k8s-infra) | Kubernetes telemetry (logs, metrics, events, traces) via upstream OpenTelemetry Collector | [README](charts/last9-k8s-infra/README.md) |
| [`l9gpu`](charts/l9gpu) | Vendor-agnostic GPU telemetry for AI/ML and HPC clusters (NVIDIA, AMD, Gaudi) | [source](https://github.com/last9/gpu-telemetry) |

## Quickstart — `last9-k8s-infra`

```bash
helm upgrade --install last9 last9/last9-k8s-infra \
  --namespace last9 --create-namespace \
  --set last9.otlpEndpoint=https://otlp.last9.io \
  --set last9.writeToken="Basic <base64>" \
  --set last9.cluster.name=my-cluster
```

OCI:

```bash
helm upgrade --install last9 oci://ghcr.io/last9/charts/last9-k8s-infra \
  --version 0.1.0 \
  --namespace last9 --create-namespace \
  --set last9.otlpEndpoint=https://otlp.last9.io \
  --set last9.writeToken="Basic <base64>" \
  --set last9.cluster.name=my-cluster
```

## Quickstart — `l9gpu`

GPU telemetry for AI/ML clusters (NVIDIA, AMD, Intel Gaudi). Canonical source: [`last9/gpu-telemetry`](https://github.com/last9/gpu-telemetry).

```bash
kubectl create secret generic l9gpu-otlp -n monitoring \
  --from-literal=OTEL_EXPORTER_OTLP_ENDPOINT=https://otlp.last9.io \
  --from-literal=OTEL_EXPORTER_OTLP_HEADERS='Authorization=Basic <base64>'

helm install l9gpu last9/l9gpu -n monitoring --create-namespace \
  --set monitoring.sink=otel \
  --set monitoring.cluster=my-cluster \
  --set otlpSecretName=l9gpu-otlp
```

OCI (canonical from gpu-telemetry repo):

```bash
helm install l9gpu oci://ghcr.io/last9/gpu-telemetry/l9gpu --version 0.2.1 -n monitoring
```

## Contributing

Issues + PRs welcome. Charts follow [Helm best practices](https://helm.sh/docs/chart_best_practices/).

Lint + install test via `ct`:

```bash
ct lint --config .github/ct.yaml --target-branch main
ct install --config .github/ct.yaml --target-branch main
```

## License

MIT — see [LICENSE](LICENSE).
