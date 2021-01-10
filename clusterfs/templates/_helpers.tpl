{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "clusterfs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "clusterfs.fullname" -}}
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
{{- define "clusterfs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}



{{/*
Common labels
*/}}
{{- define "clusterfs.labels" -}}
helm.sh/chart: {{ include "clusterfs.chart" . }}
{{ include "clusterfs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "clusterfs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "clusterfs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}




{{- define "clusterfs.pvcName" -}}
{{- default (include "clusterfs.fullname" .|lower) .Values.pvcName -}}
{{- end -}}

{{- define "clusterfs.pvName" -}}
{{- include "clusterfs.fullname" .|lower -}}
{{- end -}}

{{- define "clusterfs.storageClass" -}}
{{- include "clusterfs.fullname" .|lower -}}
{{- end -}}

{{- define "clusterfs.testPvcName" -}}
{{- if contains "Many" (.Values.accessModes|toYaml) -}}
{{- include "clusterfs.pvcName" .|lower -}}
{{- else -}}
{{- include "clusterfs.pvcName" .|lower -}}-ro
{{- end -}}
{{- end -}}

{{- define "clusterfs.glusterPath" -}}
{{- default (include "clusterfs.fullname" .) .Values.glusterfs.path -}}
{{- end -}}

{{- define "clusterfs.glusterfs" -}}
{{- $glusterfs := .Values.glusterfs -}}
{{- $_ := set $glusterfs "path" (include "clusterfs.glusterPath" .) -}}
{{- $glusterfs | toYaml  -}}
{{- end -}}

{{- define "clusterfs.backup_schedule" -}}
{{- default .Values.global.clusterfs.backup_schedule .Values.backup_schedule -}}
{{- end -}}

{{- define "clusterfs.backupPVCPrefix" -}}
{{- default .Values.global.clusterfs.backupPVCPrefix .Values.backupPVCPrefix -}}
{{- end -}}

{{- define "clusterfs.backupPVCSubpath" -}}
{{- default (printf "%s/%s" (include "clusterfs.backupPVCPrefix" .) (include "clusterfs.fullname" .)) (default .Values.global.clusterfs.backupPVCSubpath .Values.backupPVCSubpath) -}}
{{- end -}}

{{- define "clusterfs.backupPVC" -}}
{{- default .Values.global.clusterfs.backupPVC .Values.backupPVC -}}
{{- end -}}

{{- define "clusterfs.heketi_resturl" -}}
{{- default .Values.global.clusterfs.heketi_resturl .Values.heketi.resturl -}}
{{- end -}}
