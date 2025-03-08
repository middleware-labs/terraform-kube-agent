# This Doc is about installing middleware Agent using terraform for K8s platform

# Initialize Terraform
terraform init

# Validate the configuration
terraform validate

# Plan the changes
terraform plan

# Apply the changes
terraform apply

# Destroy the changes
terraform delete

# Extra Cautious while destroying
terraform plan -destroy

middleware-terraform/
├── main.tf         # Main configuration file
├── variables.tf    # Variable declarations
├── terraform.tfvars # Actual variable values
└── providers.tf    # Provider configuration
