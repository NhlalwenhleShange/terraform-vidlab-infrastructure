# VidLab — Azure Infrastructure

Terraform configuration that provisions the Azure infrastructure
for the VidLab video frame extraction service.

## Architecture

The following resources are provisioned:

- Azure Resource Group (`rg-vidlab02-prod`)
- Azure Container Registry (`vidlab02acrprod01`)
- Azure Container App Environment (`cae-vidlab02-prod`)
- Azure Container App (`app-vidlab02-prod`) — service running the VidLab image

## Usage

\`\`\`bash
terraform init
terraform plan
terraform apply
\`\`\`

## Variables

| Name | Description | Default |
|------|-------------|---------|
| `prefix` | Resource name prefix | `vidlab02` |
| `location` | Azure region | `southafricanorth` |
| `tags` | Common resource tags | see `variables.tf` |

## Outputs

| Name | Description |
|------|-------------|
| `container_app_url` | Public HTTPS URL of the deployed app |
| `acr_login_server` | ACR login server hostname |

## Notes

- The Container App is provisioned with a placeholder image.
  Real deployments are done by the app repo's CI/CD pipeline.
- A `lifecycle { ignore_changes = [template[0].container[0].image] }`
  block prevents Terraform from reverting manual deploys.

## Related

- Application repo: `github.com/NhlalwenhleShange/vidlab-app`
