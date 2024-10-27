This repo script deploys the sample from https://learn.microsoft.com/en-us/azure/container-apps/java-eureka-server?tabs=azure-cli

## Docs:
- Azure Container Apps REST AzAPI template https://learn.microsoft.com/en-us/azure/templates/microsoft.app/containerapps?pivots=deployment-language-terraform
- Java Component REST AzAPI template https://learn.microsoft.com/en-us/azure/templates/microsoft.app/managedenvironments/javacomponents?pivots=deployment-language-terraform

## Deploy:
```bash
terraform init -upgrade

terraform apply -var-file=config.tfvars

```