resource "helm_release" "postgresql" {
  name       = "my-postgres-db"               
  repository = "oci://registry-1.docker.io/bitnamicharts" 
  chart      = "postgresql"                   
  version    = "13.2.24"                       

  timeout = 900 
  
  set {
    name  = "image.tag"
    value = "latest"
  }
  
  set {
    name  = "auth.postgresPassword"
    value = var.db_password
  }

  set {
    name  = "auth.database"
    value = "myapp_db"
  }

  set {
    name  = "auth.username"
    value = "myapp_user"
  }
  

  set {
    name  = "primary.service.type"
    value = "ClusterIP"
  }


  set {
    name  = "primary.persistence.enabled"
    value = "true"
  }
  
  set {
    name  = "primary.persistence.size"
    value = "1Gi"
  }
}