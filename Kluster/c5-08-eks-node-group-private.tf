# Create AWS EKS Node Group - Private
resource "aws_eks_node_group" "eks_ng_private" {
  cluster_name    = aws_eks_cluster.eks_cluster.name

  node_group_name = "${local.name}-eks-ng-private"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = module.vpc.private_subnets
  version = var.cluster_version #(Optional: Defaults to EKS Cluster Kubernetes version)    
  
  ami_type = "AL2_x86_64"
 # pre_bootstrap_user_data = "${local.cluster_name} --b64-cluster-ca ${aws_eks_cluster.eks_cluster.certificate_authority[0].data} --apiserver-endpoint ${aws_eks_cluster.eks_cluster.endpoint} --use-max-pods false"
  capacity_type   = var.capacity_type_private
  disk_size       = var.disk_size_private
  instance_types  = var.instance_types_private
  
  
  remote_access {
    ec2_ssh_key = "eks-terraform-key"    
  }

  scaling_config {
    desired_size = var.desired_size_private
    min_size     = var.min_size_private
    max_size     = var.max_size_private
  }

  # Desired max percentage of unavailable worker nodes during node group update.
  update_config {
    max_unavailable = 1    
    #max_unavailable_percentage = 50    # ANY ONE TO USE
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
    kubernetes_config_map_v1.aws_auth,
    kubectl_manifest.cni_docs
  ] 
  tags = {
    Name = "Private-Node-Group"
    # Cluster Autoscaler Tags
    "k8s.io/cluster-autoscaler/${local.eks_cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled" = "TRUE"
  }
}