{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "glusterInmortalVolume.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "glusterInmortalVolume.fullname" -}}
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
{{- define "glusterInmortalVolume.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}



{{/*
Common labels
*/}}
{{- define "glusterInmortalVolume.labels" -}}
helm.sh/chart: {{ include "glusterInmortalVolume.chart" . }}
{{ include "glusterInmortalVolume.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "glusterInmortalVolume.selectorLabels" -}}
app.kubernetes.io/name: {{ include "glusterInmortalVolume.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}




{{- define "glusterInmortalVolume.pvcName" -}}
{{- default (include "glusterInmortalVolume.fullname" .|lower) .Values.pvcName -}}
{{- end -}}

{{- define "glusterInmortalVolume.pvName" -}}
{{- include "glusterInmortalVolume.fullname" .|lower -}}
{{- end -}}

{{- define "glusterInmortalVolume.storageClass" -}}
{{- include "glusterInmortalVolume.fullname" .|lower -}}
{{- end -}}

{{- define "glusterInmortalVolume.testPvcName" -}}
{{- if contains "Many" (.Values.accessModes|toYaml) -}}
{{- include "glusterInmortalVolume.pvcName" .|lower -}}
{{- else -}}
{{- include "glusterInmortalVolume.pvcName" .|lower -}}-ro
{{- end -}}
{{- end -}}

{{- define "glusterInmortalVolume.glusterPath" -}}
{{- default (include "glusterInmortalVolume.fullname" .) .Values.glusterfs.path -}}
{{- end -}}

{{- define "glusterInmortalVolume.glusterfs" -}}
{{- $glusterfs := .Values.glusterfs -}}
{{- $_ := set $glusterfs "path" (include "glusterInmortalVolume.glusterPath" .) -}}
{{- $glusterfs | toYaml  -}}
{{- end -}}
