## To define the general conditions that terraform will use, go to the files and modify according to the project and location:
A) Define `ec2bastion.auto.tfvars` you have to specify the instance type and key pair to use in them.

B) Define `eks.auto.tfvars` define the cluster_name.
    Note that in aws you add the local_name composed by the values of environment and project 
    file = c002-02-local-values.tf > line 11 = eks_cluster_name = "${local.name}-${var.cluster_name}"

C) Define `terraform.tfvars` to specify region, environment and project. Note that changing the aws_region will have some issue in the script (regarles of vpc availability zones that are modify in the next check).
  Will need to change the following files:
    1 - c110.02-cni.yml line 120 y 141 = check in AWS oficial site for the repo acording the region. Note that AWS have the same account for every region in US and sao pablo, making the change only for the region
    2 - c101-04-ebs-csi-install-using-helm.tf line 12 = same as before
    3 - Please add future files for aws_eks_ADDons here

D) Define `vpc.auto.tfvars` specify vpc variables: cidrs name, avz, subnets and others
change the CIDRS with each vpc that is on the same account to be able to do vpc peering if needed. Note to change de Availabilitty Zones to match the region the vpc is going to be deployed.

E) Define `iam.auto.tfvars` here you can match the eks-admin for the cluster.

## Terraform files
- c001-versions.tf  > to set terraform providers, backend configration of tfstate file and lock with dynamo db (check `___________`) 

- c002-01-generic-variables.tf > to load variable use by terraform, they can be setup in terraform.tfvars

- c002-02-local-values.tf > set the eks_cluster_name, the variable are especifies in other files
                          c002-01-generic-variables.tf > terraform.tfvars
                          c005-01-eks-variables.tf > eks.auto.tfvars
        - Understand about [Local Values][terraform local values module]

- terraform.tfvars > to load variable values by default from this file related to terraform

## VPC files
- c003-01-vpc-variables.tf > Define `Input Variables` for VPC module and reference them in VPC Terraform Module
- c003-02-vpc-module.tf > Create VPC using `Terraform Modules`
- c003-03-vpc-outputs.tf  for VPC
- vpc.auto.tfvars > to load variables values by default from this file related to VPC

## EC2 Bastion files
- c004-01-ec2bastion-variables.tf > > Define `Input Variables` for EC2 module and reference them in EC2 Terraform Module
- c004-02-ec2bastion-outputs.tf > for EC2
- c004-03-ec2bastion-securitygroups.tf > Determine Security Groups for BAstion host
- c004-04-ami-datasource.tf > Check the last AMI of AWS and list it
- c004-05-ec2bastion-instance.tf > Create EC" bastion using `Terraform Modules`
- c004-06-ec2bastion-elasticip.tf > Assign an Elastic IP for the bastion host
- c004-07-ec2bastion-provisioners.tf > Execute commands in EC2 to copy de pem file for conecting to other nodes
- ec2bastion.auto.tfvars > to load variables values by default from this file related to EC2

## EKS files
  + EKS General files
    - c005-01-eks-variables.tf
    - c005-02-eks-outputs.tf
    - c005-05-securitygroups-eks.tf
    - c005-06-eks-cluster.tf
    - c005-09-namespaces.tf
    - c007-01-kubernetes-provider.tf
    - c099-01-helm-provider.tf
  
  + IAM Section
    - c005-03-iamrole-for-eks-cluster.tf
    - c005-04-iamrole-for-eks-nodegroup.tf
    - c006-01-iam-oidc-connect-provider-variables.tf
    - c006-02-iam-oidc-connect-provider.tf
    - c008-01-iam-admin-user.tf
    - c008-02-iam-basic-user.tf
    - c009-00-iam-variables.tf
    - c009-01-iam-role-eksadmins.tf
    - c009-02-iam-group-and-user-eksadmins.tf
    - c010-01-iam-role-eksreadonly.tf
    - c010-02-iam-group-and-user-eksreadonly.tf
    - c101-02-ebs-csi-iam-policy-and-role.tf
    - c102-01-cluster-autoscaler-iam-policy-and-role.tf
    - c110-01-cni-iam-role&user.tf
    - c101-01-ebs-csi-datasources.tf
    - iam.auto.tfvars
  
  + RBAC
    - c007-02-kubernetes-configmap.tf
    - c010-03-k8s-clusterrole-clusterrolebinding.tf
    - check c110.02-cni.yml

  + ADD-ONS
    - c110-03-cni-addon.tf
    - c110.02-cni.yml > creates several resources inside eks
    - c102-02-cluster-autoscaler-install.tf
    - c103-01-promtheus.tf
    - c101-01-ebs-csi-datasources.tf
    - c101-05-ebs-csi-outputs.tf
    - c100-02-metrics-server-install.tf
    - c100-03-metrics-server-outputs.tf

  
  + EKS Public Node Groups files
    - c005-07-eks-node-group-public.tf
    - c005-05-securitygroups-eks.tf

  + EKS Private Node Groups files
    - c005-08-eks-node-group-private.tf
