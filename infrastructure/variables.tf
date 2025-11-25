variable "docker_image" {
  description = "Повний шлях до Docker образу"
  type        = string
  default     = "dasakaton/my-python-api:v1.0" 
}

variable "db_password" {
  description = "Пароль адміністратора Postgres"
  type        = string
  sensitive   = true # [SECURITY]:
}

variable "app_host" {
  description = "Доменне ім'я для доступу до API"
  type        = string
  default     = "my-api.info"
}