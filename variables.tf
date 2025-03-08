variable "environment" {
  description = "Environment label for resources"
  type        = string
  default     = "dev"
}

variable "middleware_api_key" {
  description = "API key for Middleware"
  type        = string
  sensitive   = true
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "local-dev-cluster"
}

variable "excluded_namespaces" {
  description = "List of namespaces to exclude from auto-instrumentation"
  type        = list(string)
  default     = []
}