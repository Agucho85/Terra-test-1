resource "aws_eks_addon" "coredns" {
  cluster_name      = aws_eks_cluster.eks_cluster.name
  addon_name        = "coredns"
  resolve_conflicts = "OVERWRITE"
  depends_on        = [helm_release.prometheus]
}