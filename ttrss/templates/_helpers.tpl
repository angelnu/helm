{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ttrss.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ttrss.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ttrss.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "ttrss.labels" -}}
helm.sh/chart: {{ include "ttrss.chart" . }}
{{ include "ttrss.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "ttrss.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ttrss.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "ttrss.internalPort" -}}
{{- if .Values.internal_self_signed -}}
4443
{{- else -}}
8080
{{- end -}}
{{- end -}}

{{- define "ttrss.internalHTTPScheme" -}}
{{- if .Values.internal_self_signed -}}
HTTPS
{{- else -}}
HTTP
{{- end -}}
{{- end -}}

{{- define "ttrss.servicePort" -}}
{{ default (include "ttrss.internalPort" .) .Values.service.port }}
{{- end -}}

{{- define "ttrss.TTRSS_URL" -}}
{{- if .Values.ingress.enabled -}}
{{ (index .Values.ingress.hosts 0).host }}
{{- else -}}
{{ printf "%s:%s" "localhost" (include "ttrss.servicePort" .) }}
{{- end -}}
{{- end -}}

{{- define "ttrss.test_url" -}}
{{- if .Values.ingress.enabled -}}
http{{ if .Values.ingress.tls          }}s{{ end }}://{{ (index .Values.ingress.hosts 0).host }}
{{- else -}}
http{{ if .Values.internal_self_signed }}s{{ end }}://{{ printf "%s:%s" (include "ttrss.fullname" .) (include "ttrss.servicePort" .) }}
{{- end -}}
{{- end -}}

internal_self_signed


{{- define "ttrss.db" -}}
{{ .Release.Name }}-db-postgres
{{- end -}}

{{- define "ttrss.superuser" -}}
{{- default (default dict (default dict .Values.global).postgresop).superuser .Values.db.global.postgresop.superuser -}}
{{- end -}}

{{- define "ttrss.superuser_secret" -}}
{{ include "ttrss.superuser" . }}.{{ include "ttrss.db" . }}.credentials
{{- end -}}
