# Install Kubernetes istio mesh system with Helm and kubectl for addons
# Resource: Helm Release an Kubectl

resource "helm_release" "istio_base" {
  name       = "${local.name}-istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts" 
  chart      = "base"
  namespace = "istio-system"

  depends_on = [
    aws_eks_cluster.eks_cluster,
    helm_release.ebs_csi_driver,
    kubernetes_namespace_v1.namespace,
    kubernetes_namespace_v1.istio-system
  ]
}

resource "helm_release" "istio_cni" {
  name       = "${local.name}-istio-cni"
  repository = "https://istio-release.storage.googleapis.com/charts" 
  chart      = "cni"
  namespace = "istio-system"

  depends_on = [
    aws_eks_cluster.eks_cluster,
    helm_release.ebs_csi_driver,
    kubernetes_namespace_v1.namespace,
    kubernetes_namespace_v1.istio-system
  ]
}

resource "helm_release" "istiod" {
  name       = "${local.name}-istiod"
  repository = "https://istio-release.storage.googleapis.com/charts" 
  chart      = "istiod"
  namespace = "istio-system"

  set {
    name = "meshConfig.accessLogFile"
    value = "/dev/stdout"
  }

  depends_on = [
    aws_eks_cluster.eks_cluster,
    helm_release.ebs_csi_driver,
    kubernetes_namespace_v1.namespace,
    kubernetes_namespace_v1.istio-system,
    helm_release.istio_base,
    helm_release.istio_cni
  ]
}

 resource "helm_release" "istio_ingress" {
   name       = "${local.name}-ingress"
   repository = "https://istio-release.storage.googleapis.com/charts" 
   chart      = "gateway"
   namespace = "istio-ingress"
   

   depends_on = [
     aws_eks_cluster.eks_cluster,
     helm_release.ebs_csi_driver,
     kubernetes_namespace_v1.namespace,
     kubernetes_namespace_v1.istio-ingress,
     helm_release.istiod
   ]
   set {
     value  = "NodePort"
     name = "service.type"
   }
 }


data "kubectl_file_documents" "prometheus_docs" {
    content = file("c104-04-prometheus.yaml")
}

# Resource: kubectl_manifest which will create k8s Resources from the URL specified in above datasource
resource "kubectl_manifest" "prometheus_docs" {
    depends_on = [
        aws_eks_cluster.eks_cluster,
        helm_release.ebs_csi_driver,
        kubernetes_namespace_v1.namespace,
        kubernetes_namespace_v1.istio-system
  ]
    for_each = data.kubectl_file_documents.prometheus_docs.manifests
    yaml_body = each.value
}

data "kubectl_file_documents" "grafana_docs" {
    content = file("c104-05-grafana.yaml")
}

# Resource: kubectl_manifest which will create k8s Resources from the URL specified in above datasource
resource "kubectl_manifest" "grafana_docs" {
    depends_on = [
        aws_eks_cluster.eks_cluster,
        helm_release.ebs_csi_driver,
        kubernetes_namespace_v1.namespace,
        kubernetes_namespace_v1.istio-system,
        helm_release.istiod
  ]
    for_each = data.kubectl_file_documents.grafana_docs.manifests
    yaml_body = each.value
}

data "kubectl_file_documents" "kiali_docs" {
    content = file("c104-06-kiali.yaml")
}

# Resource: kubectl_manifest which will create k8s Resources from the URL specified in above datasource
resource "kubectl_manifest" "kiali_docs" {
    depends_on = [
        aws_eks_cluster.eks_cluster,
        helm_release.ebs_csi_driver,
        kubernetes_namespace_v1.namespace,
        kubernetes_namespace_v1.istio-system,
        helm_release.istiod
  ]
    for_each = data.kubectl_file_documents.kiali_docs.manifests
    yaml_body = each.value
}