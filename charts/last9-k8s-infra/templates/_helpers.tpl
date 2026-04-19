{{/*
Last9 auth secret name.
*/}}
{{- define "last9.authSecretName" -}}
{{- if .Values.last9.existingSecret -}}
{{ .Values.last9.existingSecret }}
{{- else -}}
{{ include "last9.fullname" . }}-otlp-auth
{{- end -}}
{{- end -}}

{{- define "last9.fullname" -}}
{{- default .Chart.Name .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "last9.clusterCollectorLabels" -}}
app.kubernetes.io/name: last9-cluster-collector
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: cluster-collector
app.kubernetes.io/part-of: last9-k8s-infra
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{- define "last9.clusterCollectorSelectorLabels" -}}
app.kubernetes.io/name: last9-cluster-collector
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Shared OTLP exporter block — referenced by both agent + cluster via global config merge.
Injects Authorization header from secret.
*/}}
{{- define "last9.otlpExporter" -}}
otlphttp/last9:
  endpoint: {{ required "last9.otlpEndpoint required" .Values.last9.otlpEndpoint | quote }}
  auth:
    authenticator: headers_setter
{{- end -}}

{{/*
Resource attributes applied to all signals.
*/}}
{{- define "last9.resourceProcessor" -}}
resource/last9:
  attributes:
    - key: k8s.cluster.name
      value: {{ required "last9.cluster.name required" .Values.last9.cluster.name | quote }}
      action: upsert
    - key: deployment.environment
      value: {{ .Values.last9.environment | quote }}
      action: upsert
{{- end -}}
