{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "postgresop.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "postgresop.fullname" -}}
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
{{- define "postgresop.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "postgresop.labels" -}}
helm.sh/chart: {{ include "postgresop.chart" . }}
{{ include "postgresop.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "postgresop.selectorLabels" -}}
app.kubernetes.io/name: {{ include "postgresop.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "postgresop.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "postgresop.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}



{{- define "postgresop.db" -}}
{{- include "postgresop.fullname" .|lower -}}-postgres
{{- end -}}

{{- define "postgresop.superuser" -}}
{{- default .Values.global.postgresop.superuser .Values.superuser -}}
{{- end -}}

{{- define "postgresop.superuser_secret" -}}
{{ include "postgresop.superuser" . }}.{{ include "postgresop.db" . }}.credentials
{{- end -}}

{{- define "postgresop.pvName" -}}
{{- include "postgresop.fullname" .|lower -}}
{{- end -}}

{{- define "postgresop.storageClass" -}}
{{- include "postgresop.fullname" .|lower -}}
{{- end -}}

{{- define "postgresop.accessModes" -}}
{{- default .Values.global.postgresop.accessModes .Values.accessModes |toYaml -}}
{{- end -}}

{{- define "postgresop.persistentVolumeReclaimPolicy" -}}
{{- if (default .Values.global.postgresop.persistent .Values.persistent) -}}
Retain
{{- else -}}
Recycle
{{- end -}}
{{- end -}}

{{- define "postgresop.replicaSize" -}}
{{- default .Values.global.postgresop.replicaSize .Values.replicaSize -}}
{{- end -}}

{{- define "postgresop.replicaCount" -}}
{{- default .Values.global.postgresop.replicaCount .Values.replicaCount -}}
{{- end -}}

{{- define "postgresop.replicaNodes" -}}
{{- default .Values.global.postgresop.replicaNodes .Values.replicaNodes | join "," -}}
{{- end -}}

{{- define "postgresop.localPrefix" -}}
{{- default .Values.global.postgresop.localPrefix .Values.localPrefix -}}
{{- end -}}

{{- define "postgresop.localPath" -}}
{{- default (printf "%s/%s" (include "postgresop.localPrefix" .) (include "postgresop.fullname" .)) (default .Values.global.postgresop.localPath .Values.localPath) -}}
{{- end -}}

{{- define "postgresop.backup_schedule" -}}
{{- default .Values.global.postgresop.backup_schedule .Values.backup_schedule -}}
{{- end -}}

{{- define "postgresop.backupPVCPrefix" -}}
{{- default .Values.global.postgresop.backupPVCPrefix .Values.backupPVCPrefix -}}
{{- end -}}

{{- define "postgresop.backupPVCSubpath" -}}
{{- default (printf "%s/%s" (include "postgresop.backupPVCPrefix" .) (include "postgresop.fullname" .)) (default .Values.global.postgresop.backupPVCSubpath .Values.backupPVCSubpath) -}}
{{- end -}}

{{- define "postgresop.backupPVC" -}}
{{- if (default .Values.global.postgresop.persistent .Values.persistent) -}}
{{- required "A PVC for backups is required when persistent is enabled" (default .Values.global.postgresop.backupPVC .Values.backupPVC) -}}
{{- end -}}
{{- end -}}
