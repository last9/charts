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

## Contributing

Issues + PRs welcome. Charts follow [Helm best practices](https://helm.sh/docs/chart_best_practices/).

Lint + install test via `ct`:

```bash
ct lint --config .github/ct.yaml --target-branch main
ct install --config .github/ct.yaml --target-branch main
```

## License

MIT — see [LICENSE](LICENSE).
