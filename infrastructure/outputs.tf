output "api_url" {
  description = "URL для доступу до API"
  value       = "http://${var.app_host}/"
}

output "postgres_service_name" {
  description = "Внутрішнє ім'я сервісу бази даних"
  value       = "my-postgres-db-postgresql"
}

output "deployment_status" {
  value = "Інфраструктура успішно розгорнута! Перевірте статус подів: kubectl get pods"
}