# Security Group for EKS Node Group - Placeholder file
# Los SG se crean por defecto cuando levantas el eks-node-group. En este archivo lo podes modificar si fuera necesario. 
/*
# AWS EC2 Security Group Terraform Module
# Security Group for Public Bastion Host
module "public_eks-nodegroup_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.5.0"

  name = "${local.name}-public-eks-nodegroup-sg"
  description = "Security Group with SSH port open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id = module.vpc.vpc_id
  # Ingress Rules & CIDR Blocks
  ingress_rules = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags = local.common_tags

  */