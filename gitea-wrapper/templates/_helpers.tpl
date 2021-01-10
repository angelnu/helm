{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gitea-wrapper.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gitea-wrapper.fullname" -}}
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
{{- define "gitea-wrapper.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "gitea-wrapper.labels" -}}
helm.sh/chart: {{ include "gitea-wrapper.chart" . }}
{{ include "gitea-wrapper.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "gitea-wrapper.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gitea-wrapper.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "gitea-wrapper.persistentVolume-mountOptions" -}}
{{- if .Values.persistentVolume.nfs }}
{{- if .Values.persistentVolume.nfs.mountOptions -}}
{{- .Values.persistentVolume.nfs.mountOptions | toYaml }}
{{- else if and .Values.global.nfs .Values.global.nfs.mountOptions -}}
{{- .Values.global.nfs.mountOptions | toYaml }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "gitea-wrapper.persistentVolume-nfs-server" -}}
{{- if and .Values.persistentVolume.nfs .Values.persistentVolume.nfs.server -}}
{{- .Values.persistentVolume.nfs.server | toYaml }}
{{- else if and .Values.global.nfs .Values.global.nfs.server -}}
{{- .Values.global.nfs.server | toYaml }}
{{- else -}}
{{- required "server required for NFS volume" .Values.persistentVolume.nfs.server -}}
{{- end -}}
{{- end -}}

{{- define "gitea-wrapper.persistentVolume-nfs-path" -}}
{{- if .Values.persistentVolume.nfs -}}
{{- required "path required for NFS volume" .Values.persistentVolume.nfs.path -}}
{{- end -}}
{{- end -}}
