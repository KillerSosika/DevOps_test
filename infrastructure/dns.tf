
# Це приклад того, як налаштовується автоматичний DNS у Production.
# Оскільки у нас локальний Minikube, ми використовуємо provider "inmemory" для демонстрації,
# або коментуємо це, пояснюючи, що потрібен токен Cloudflare/AWS.

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  namespace  = "default"

  # У реальному житті тут був би Cloudflare або AWS
  set {
    name  = "provider"
    value = "cloudflare" # або "aws"
  }

  # Тут ми б передали API токен (через Secret!)
  # set {
  #   name  = "cloudflare.apiToken"
  #   value = var.cloudflare_token
  # }

  set {
    name  = "policy"
    value = "sync" 
  }
  
  set {
    name  = "domainFilters[0]"
    value = "my-api.info"
  }
}