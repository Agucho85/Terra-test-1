# Install Kubernetes Metrics Server using HELM
# Resource: Helm Release 
# resource "helm_release" "prometheus" {
#   name       = "${local.name}-prometheus"
#   repository = "https://prometheus-community.github.io/helm-charts" 
#   chart      = "prometheus"
#   namespace = "prometheus-system"

#   depends_on = [
#     aws_eks_cluster.eks_cluster,
#     helm_release.ebs_csi_driver,
#     kubernetes_namespace_v1.namespace,
#     kubernetes_namespace_v1.prometheus-system
#   ]
# }
