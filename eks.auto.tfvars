cluster_name = "multitenant"
cluster_service_ipv4_cidr = "172.20.0.0/16" # cambiarlo si hay otro cluster en la misma cuenta (tema de vpc peering) 
cluster_version = "1.23"  #la version del cluster de AWS.
cluster_endpoint_private_access = true  # se utiliza para conectarse a a los nodos en subnet privada con kubectl referencia https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html
cluster_endpoint_public_access = true # si se desahibilita esto, no vas a poder instalar ningun helm chart que se encuentre en internet 
cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"] # las ip autorizadas a realizar comandos kubectl a traves de los cluster_endopoints
eks_oidc_root_ca_thumbprint = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280" # Valido según documentacion hasta 2037 igual
# Variables de EC2 del grupo de nodos
capacity_type_private = "ON_DEMAND"  # puesto para que solo saque precio mas bajo posible
disk_size_private = "10"
instance_types_private = ["t3a.large"]
desired_size_private = "3"
min_size_private = "2"
max_size_private = "5"
namespace = [
    "stage-ocptech",
    "dev-ocptech"
 ]