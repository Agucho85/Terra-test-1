resource "kubernetes_namespace_v1" "prometheus-system" {
  metadata {
    name = "prometheus-system"
  }
}