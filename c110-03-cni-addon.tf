# Install VPC-CNI
# Datasource: kubectl_file_documents 
# This provider provides a data resource kubectl_file_documents to enable ease of splitting multi-document yaml content.
data "kubectl_file_documents" "cni_docs" {
    content = file("c110.02-cni.yml")
}

# Resource: kubectl_manifest which will create k8s Resources from the URL specified in above datasource
resource "kubectl_manifest" "cni_docs" {
    depends_on = [aws_eks_cluster.eks_cluster, aws_iam_role.eks_admin_role, kubernetes_config_map_v1.aws_auth, aws_eks_node_group.eks_ng_private]
    for_each = data.kubectl_file_documents.cni_docs.manifests
    yaml_body = each.value
}
