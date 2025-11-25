param (
    [string]$Action = "help"
)

$ErrorActionPreference = "Stop"

function Show-Help {
    Write-Host "Usage: .\manage.ps1 [command]" -ForegroundColor Cyan
    Write-Host "Commands:"
    Write-Host "  deploy   - Apply Terraform configuration"
    Write-Host "  destroy  - Destroy infrastructure"
    Write-Host "  test     - Run connection test"
    Write-Host "  rebuild  - Re-build and Push Docker image (requires login)"
}

if ($Action -eq "deploy") {
    Write-Host "🚀 Deploying Infrastructure..." -ForegroundColor Green
    Set-Location infrastructure
    if (-not (Test-Path "secrets.tfvars")) {
        Set-Content -Path "secrets.tfvars" -Value 'db_password = "DemoPassWord123!"'
    }
    terraform apply -var-file="secrets.tfvars" -auto-approve
    Set-Location ..
}
elseif ($Action -eq "destroy") {
    Write-Host "💥 Destroying Infrastructure..." -ForegroundColor Yellow
    Set-Location infrastructure
    terraform destroy -var-file="secrets.tfvars" -auto-approve
    Set-Location ..
}
elseif ($Action -eq "test") {
    Write-Host "🧪 Testing API..." -ForegroundColor Cyan
    .\validate.ps1
}
elseif ($Action -eq "rebuild") {
    Write-Host "🐳 Building Docker Image..." -ForegroundColor Cyan
    Set-Location application
    docker build -t dasakaton/my-python-api:v1.0 .
    docker push dasakaton/my-python-api:v1.0
    kubectl rollout restart deployment python-api
    Set-Location ..
}
else {
    Show-Help
}