# =============================================================================
# [BLUEPRINT] Production Monitoring Stack
# =============================================================================
# Status: DISABLED (Код підготовлено для Production, але вимкнено для економії ресурсів локально)

# Kube Prometheus Stack (Prometheus Operator, Grafana, Alertmanager)
# resource "helm_release" "prometheus_stack" {
#   name             = "monitoring"
#   repository       = "https://prometheus-community.github.io/helm-charts"
#   chart            = "kube-prometheus-stack"
#   namespace        = "monitoring"
#   create_namespace = true
#
#   # Grafana Settings
#   set {
#     name  = "grafana.enabled"
#     value = "true"
#   }
#
#   set {
#     name  = "grafana.adminPassword"
#     value = "admin" # Use var.grafana_password in Prod
#   }
#
#   # Grafana Ingress
#   set {
#     name  = "grafana.ingress.enabled"
#     value = "true"
#   }
#   
#   set {
#     name  = "grafana.ingress.hosts[0]"
#     value = "grafana.local"
#   }
#
#   # Prometheus Storage (Ephemeral for testing)
#   set {
#     name  = "prometheus.prometheusSpec.storageSpec"
#     value = "" 
#   }
# }

# ServiceMonitor for Python API
# resource "kubernetes_manifest" "api_service_monitor" {
#   manifest = {
#     apiVersion = "monitoring.coreos.com/v1"
#     kind       = "ServiceMonitor"
#     metadata = {
#       name      = "python-api-monitor"
#       namespace = "monitoring"
#       labels = {
#         release = "monitoring"
#       }
#     }
#     spec = {
#       selector = {
#         matchLabels = {
#           app = "python-api"
#         }
#       }
#       endpoints = [
#         {
#           port = "http"
#           path = "/metrics"
#         }
#       ]
#     }
#   }
# }