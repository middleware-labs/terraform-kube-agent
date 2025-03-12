resource "kubernetes_namespace" "middleware_agent" {
  metadata {
    name = "mw-agent-ns"
    labels = {
      environment                    = var.environment
      "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-name"      = "mw-agent"
      "meta.helm.sh/release-namespace" = "mw-agent-ns"
    }
  }
}

# Install cert-manager if enabled (required for middleware auto-instrumentation)
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "v1.14.5"
  timeout    = 600

  atomic          = true
  wait            = true
  cleanup_on_fail = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  create_namespace = true
}

# Install middleware agent with auto-instrumentation using local chart
resource "helm_release" "middleware_agent" {
  name             = "mw-agent"
  repository       = "https://helm.middleware.io" 
  chart            = "mw-kube-agent-v3"
  namespace        = kubernetes_namespace.middleware_agent.metadata[0].name
  create_namespace = false
  version          = "v1.1.0"

  timeout = 600

  atomic          = true
  wait            = true
  cleanup_on_fail = true

  set {
    name  = "global.mw.apiKey"
    value = var.middleware_api_key
  }

  set {
    name  = "global.mw.target"
    value = "https://sliay.middleware.io:443"
  }

  set {
    name  = "global.clusterMetadata.name"
    value = var.cluster_name
  }

  set {
    name  = "mw-autoinstrumentation.enabled"
    value = "true"
  }

  # Optional namespace exclusions
  dynamic "set" {
    for_each = length(var.excluded_namespaces) > 0 ? [1] : []
    content {
      name  = "mw-autoinstrumentation.webhook.userExcludedNamespaces"
      value = "{${join(",", var.excluded_namespaces)}}"
    }
  }

  depends_on = [helm_release.cert_manager, kubernetes_namespace.middleware_agent]
}
