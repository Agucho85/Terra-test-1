# Install Cluster Autoscaler using HELM
# Resource: Helm Release 
resource "helm_release" "cluster_autoscaler_release" {
  depends_on = [
    aws_iam_role.cluster_autoscaler_iam_role,
    aws_eks_cluster.eks_cluster,
    helm_release.ebs_csi_driver
  ]

  name       = "${local.name}-ca"

  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"

  namespace = "kube-system"   

  set {
    name  = "cloudProvider"
    value = "aws"
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = aws_eks_cluster.eks_cluster.id
  }

  set {
    name  = "awsRegion"
    value = var.aws_region
  }

  set {
    name  = "rbac.serviceAccount.create"
    value = "true"
  }

  set {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "${aws_iam_role.cluster_autoscaler_iam_role.arn}"
  }
  # Additional Arguments (Optional) - To Test How to pass Extra Args for Cluster Autoscaler go to https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler
  set {
    name = "extraArgs.scan-interval"
    value = "10s"
  }    
}