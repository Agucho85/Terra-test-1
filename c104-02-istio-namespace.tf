resource "kubernetes_namespace_v1" "istio-system" {
  metadata {
    name = "istio-system"
  }
}
resource "kubernetes_namespace_v1" "istio-ingress" {
  metadata {
    name = "istio-ingress"
  }
}