# last9-k8s-infra

Kubernetes telemetry collection for [Last9](https://last9.io) via upstream OpenTelemetry Collector.

Ships two Collector instances:

- **agent** — daemonset via upstream `opentelemetry-collector` subchart. Logs (filelog), host metrics, kubelet metrics, k8sattributes, OTLP receiver for app traces/metrics.
- **cluster collector** — single-replica deployment via this chart's own templates. Cluster-level metrics (`k8s_cluster` receiver), Kubernetes events (`k8sobjects` receiver).

Uses `otel/opentelemetry-collector-contrib:0.150.1`.

## Install

```bash
helm repo add last9 https://last9.github.io/charts
helm repo update

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

## Values

| Key | Default | Purpose |
|---|---|---|
| `last9.otlpEndpoint` | `""` | OTLP HTTP endpoint. Required. |
| `last9.writeToken` | `""` | Full `Authorization` header value. |
| `last9.existingSecret` | `""` | Pre-existing secret with key `authorization` (GitOps). |
| `last9.cluster.name` | `""` | Cluster identity. Required. |
| `last9.environment` | `production` | `deployment.environment` attribute. |
| `agent.presets.logsCollection.enabled` | `true` | Filelog from `/var/log/pods`. |
| `agent.presets.hostMetrics.enabled` | `true` | Node CPU/memory/disk/net. |
| `agent.presets.kubeletMetrics.enabled` | `true` | Pod/container metrics from kubelet. |
| `agent.presets.kubernetesAttributes.enabled` | `true` | Enrich signals with pod labels/annotations. |
| `clusterCollector.enabled` | `true` | Enable cluster-scope Deployment (metrics + events). |
| `clusterCollector.metrics.enabled` | `true` | `k8s_cluster` receiver — cluster resource state. |
| `clusterCollector.events.enabled` | `true` | `k8sobjects` receiver — Kubernetes events. |
| `opentelemetry-operator.enabled` | `false` | Install OpenTelemetry Operator + Instrumentation CR for auto-instrumentation. |
| `instrumentation.enabled` | `true` | Render Instrumentation CR (requires operator enabled). |
| `instrumentation.sampler.argument` | `"1.0"` | Trace sampling ratio (0.0–1.0). |
| `kube-prometheus-stack.enabled` | `false` | Bundle Prometheus Operator + kube-state-metrics + node-exporter. Enable only if cluster has no existing Prometheus Operator. |

Full agent subchart values passthrough under `agent.*`. See [opentelemetry-collector chart](https://github.com/open-telemetry/opentelemetry-helm-charts/tree/main/charts/opentelemetry-collector).
Cluster collector knobs: `clusterCollector.{replicaCount,resources,nodeSelector,tolerations,affinity,image}`.

### Auto-instrumentation

Enable operator + annotate workloads:

```bash
helm upgrade last9 last9/last9-k8s-infra \
  --reuse-values \
  --set opentelemetry-operator.enabled=true
```

Annotate pods (examples):

```yaml
metadata:
  annotations:
    instrumentation.opentelemetry.io/inject-java: "last9/last9"
    # or inject-python, inject-nodejs, inject-dotnet, inject-go
```

### Bundled Prometheus (optional)

If no existing Prometheus Operator:

```bash
helm upgrade last9 last9/last9-k8s-infra \
  --reuse-values \
  --set kube-prometheus-stack.enabled=true
```

## Upgrade

```bash
helm repo update
helm upgrade last9 last9/last9-k8s-infra -n last9 --reuse-values
```

## Uninstall

```bash
helm uninstall last9 -n last9
```

## Status

`0.1.0` — MVP. Includes OTel Operator + Instrumentation (opt-in) and kube-prometheus-stack bundle (opt-in). Deferred: GKE Autopilot preset, network monitoring, change_events preset. GPU telemetry lives in [last9/gpu-telemetry](https://github.com/last9/gpu-telemetry).
