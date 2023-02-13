# EKS Cluster Input Variables
variable "cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  type        = string
  default     = "eksdemo"
}

variable "cluster_service_ipv4_cidr" {
  description = "service ipv4 cidr for the kubernetes cluster"
  type        = string
  default     = null
}

variable "cluster_version" {
  description = "Kubernetes minor version to use for the EKS cluster (for example 1.21)"
  type        = string
  default     = null
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. When it's set to `false` ensure to have a proper private access with `cluster_endpoint_private_access = true`."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# EKS Node Group Variables
## Placeholder space you can create if required

variable "capacity_type_private" {
  description = "Especify what kind od capacity do you need for cluster ON_DEMAND or SPOT"
  type        = string
  default     = "ON_DEMAND"
}

variable "disk_size_private" {
  description = "Especify the size of the disk do you need "
  type        = string
  default     = "20"
}

variable "instance_types_private" {
  description = "Especify the type of the EC2 do you need"
  type        = list(string)
  default     = ["t2.small", "t3.medium", "m5.large"]
}

variable "desired_size_private" {
  description = "Desired size of de autoscaling group in private node gruop."
  type        = string
  default     = "1"
}

variable "min_size_private" {
  description = "Minimum size of de autoscaling group in private node gruop."
  type        = string
  default     = "1"
}

variable "max_size_private" {
  description = "Maximum size of de autoscaling group in private node gruop."
  type        = string
  default     = "2"
}

variable "namespace" {
  description = "Especify the namespace to create"
  type = set(string)
  default   = [ 
    "dev",
    "stage",
    "other"
  ]
 }