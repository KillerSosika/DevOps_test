resource "kubernetes_horizontal_pod_autoscaler_v2" "api_hpa" {
  metadata {
    name = "python-api-hpa"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment_v1.api_deployment.metadata[0].name
    }

    min_replicas = 2  # Для відмовостійкості (High Availability)
    max_replicas = 5  # Щоб не з'їсти всі ресурси ноута

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type               = "Utilization"
          average_utilization = 60 
        }
      }
    }
    
    metric {
      type = "Resource"
      resource {
        name = "memory"
        target {
          type               = "Utilization"
          average_utilization = 80
        }
      }
    }
  }
}