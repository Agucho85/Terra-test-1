# Install Kubernetes Metrics Server using HELM
# Resource: Helm Release 
resource "helm_release" "metrics_server_release" {
  name       = "${local.name}-metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace = "kube-system"   

  depends_on = [
    aws_eks_cluster.eks_cluster,
    helm_release.ebs_csi_driver,
    kubernetes_namespace_v1.namespace,
    # helm_release.prometheus
  ]
}
