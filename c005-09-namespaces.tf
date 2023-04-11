# Resource: k8s namespace
resource "kubernetes_namespace_v1" "namespace" {
  for_each = var.namespace
  metadata {
    name = each.key
    labels = {
      istio-injection = "enabled"
    }
  }
}