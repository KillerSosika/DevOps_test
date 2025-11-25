# Коротко: секрети/конфіги і деплой для тестового кластера
resource "kubernetes_secret" "api_secrets" {
    metadata { name = "api-secrets" }
    data = {
        db_password = var.db_password
    }
}

resource "kubernetes_config_map" "api_config" {
    metadata { name = "api-config" }
    data = {
        DB_HOST = "my-postgres-db-postgresql"
        DB_USER = "myapp_user"
    }
}

resource "kubernetes_deployment_v1" "api_deployment" {
    metadata { name = "python-api" }

    spec {
        replicas = 1

        selector {
            match_labels = { app = "python-api" }
        }

        template {
            metadata { labels = { app = "python-api" } }

            spec {
                container {
                    name  = "api-container"
                    image = var.docker_image
                    image_pull_policy = "Always"

                    port { container_port = 5000 }

                    # Прості перевірки здоров'я
                    liveness_probe {
                        http_get { path = "/healthz" port = 5000 }
                        initial_delay_seconds = 5
                        period_seconds        = 10
                    }

                    readiness_probe {
                        http_get { path = "/healthz" port = 5000 }
                        initial_delay_seconds = 5
                        period_seconds        = 10
                    }

                    # Контекст без довгих пояснень
                    security_context {
                        # Для тесту іноді false; у проді краще користувача в образі + true
                        run_as_non_root = false
                        # read_only_root_filesystem = true
                    }

                    env_from {
                        config_map_ref { name = kubernetes_config_map.api_config.metadata[0].name }
                    }

                    env {
                        name = "DB_PASSWORD"
                        value_from {
                            secret_key_ref {
                                name = kubernetes_secret.api_secrets.metadata[0].name
                                key  = "db_password"
                            }
                        }
                    }

                    resources {
                        limits = { cpu = "500m" memory = "512Mi" }
                        requests = { cpu = "100m" memory = "128Mi" }
                    }
                }
            }
        }
    }
}

resource "kubernetes_service_v1" "api_service" {
    metadata { name = "python-api-service" }
    spec {
        selector = { app = "python-api" }
        port {
            port        = 80
            target_port = 5000
        }
        type = "ClusterIP"
    }
}

resource "kubernetes_ingress_v1" "api_ingress" {
    metadata {
        name = "api-ingress"
        annotations = {
            "kubernetes.io/ingress.class" = "nginx"
        }
    }

    spec {
        rule {
            host = var.app_host
            http {
                path {
                    path = "/"
                    path_type = "Prefix"
                    backend {
                        service {
                            name = kubernetes_service_v1.api_service.metadata[0].name
                            port { number = 80 }
                        }
                    }
                }
            }
        }
    }
}
