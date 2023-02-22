# To define the general conditions that terraform will use, go to the files and modify according to the project and location:
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

E) Define `iam.auto.tfvars` here you can match the eks-admin for the cluster. ADD ADO-AWS conection USER in this file!!


# BEFORE ANY APPLY: CHECK
  ## For new EKS
    1 - Check Backend in c001-versions.tf: Go to AWS Account
      a - Create a bucket in the region the eks is going to be deployed, determine the path (create folders /cluster/tfstate/), to hold the tfstate file.
      b - Create a Dynamodb table with the eks_cluster_name
    2 - Form conections with ADO and AWS.
      In AWS: 
        - Create a IAM user with Administrator Acces (better to limit the permisions)
          User_name should be ADO-AWS-<AccountID_of_AWS>-<AWS-REGION>
            This User has a region limitation to perform some action (perform AWS actions)
            You will need acceses keys, for programmatic access.
              Save credencials in 1password:
                ITEM = login 
                Title = User_name as title)
                File = the acces key file should be named User_name-accesskeys
      In ADO:
        - Go to the Project Settings, create a new service conection "AWS for Terraform".
          You will need to fill:
            - Access key id
            - Secret access key
            - Region
            - Service conection name > same as user ADO-AWS-<AccountID_of_AWS>-<AWS-REGION>
  ## For any EKS:
   - Check the files called *.tfvars and change them as needed
   - Also for changing Region (ECR repositories for aws addons), private key
   - Check backend configuration in c001-versions.tf 
   - Check adn compare versions of Terraform provider, installed with cli and c001-versions.tf

# Terraform Commands

  ## Create EKS Cluster
    terraform init  >> Wil download all needed modules to create all resources.
    terraform validate  >> Perform a sintaxis check for HCL 
    terraform plan --out example_plan  >> Perform a plan that will be executed
        **If you have issues and the tfstate got lock please, confirm no one is working on the cluster and perform:
          terraform force-unlock <some-hash-abc-123> (this cames in error mistake)**
    terraform apply example_plan (this command has the auto-approve implicit)

  ## If EKS Cluster already create as per previous sections JUST VERIFY
    a - Check de ADO user that will modify the cluster has RBAC and IAM permission to do it. If not add it. The normal step is to add the user to the group that has the eks-admin role (witch has the the policy to make changes to the cluster).
    b - First task should be to  add the profile in the ADO server that run the command:
       aws eks --region <AWS-REGION> update-kubeconfig --name <EKS-cluster-name> --profile <eks-admin-role-of-AWS>
                        aws_region                            aws_eks_cluster.eks_cluster   ${local.name}-eks-admin-role
    
    terraform init
    terraform state list  

  ## Destroy a cluster    
    terraform destroy  > you will need to execute it 4 times and go to the AWS account an erase de log gruop created for the eks. 

# Terraform files
- c001-versions.tf  > to set terraform providers, backend configration of tfstate file and lock with dynamo db (check `bucket and dynamodb table` if they exists) 

- c002-01-generic-variables.tf > to load variable use by terraform, they can be setup in terraform.tfvars

- c002-02-local-values.tf > set the eks_cluster_name, the variable are especifies in other files
                          c002-01-generic-variables.tf > terraform.tfvars
                          c005-01-eks-variables.tf > eks.auto.tfvars
        - Understand about [Local Values][terraform local values module]

- terraform.tfvars > to load variable values by default from this file related to terraform

# VPC files
- c003-01-vpc-variables.tf > Define `Input Variables` for VPC module and reference them in VPC Terraform Module
- c003-02-vpc-module.tf > Create VPC using `Terraform Modules`
- c003-03-vpc-outputs.tf  for VPC
- vpc.auto.tfvars > to load variables values by default from this file related to VPC

# EC2 Bastion files
- c004-01-ec2bastion-variables.tf > > Define `Input Variables` for EC2 module and reference them in EC2 Terraform Module
- c004-02-ec2bastion-outputs.tf > for EC2
- c004-03-ec2bastion-securitygroups.tf > Determine Security Groups for BAstion host
- c004-05-ec2bastion-instance.tf > Create EC" bastion using `Terraform Modules`
- c004-06-ec2bastion-elasticip.tf > Assign an Elastic IP for the bastion host
- c004-07-ec2bastion-provisioners.tf > Execute commands in EC2 to copy de pem file for conecting to other nodes
- ec2bastion.auto.tfvars > to load variables values by default from this file related to EC2

# EKS files
  ## EKS General files
    - c005-01-eks-variables.tf
    - c005-05-securitygroups-eks.tf
    - c005-06-eks-cluster.tf
    - c005-09-namespaces.tf
    - c007-01-kubernetes-provider.tf
    - c099-01-helm-provider.tf
    - eks.auto.tfvars
  
  ## IAM Section
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
  
  ## RBAC
    - c007-02-kubernetes-configmap.tf
    - c010-03-k8s-clusterrole-clusterrolebinding.tf
    - check c110.02-cni.yml
    - for cluster autosclaer, csi, prometheus, metrics

  ## ADD-ONS
    - c110-03-cni-addon.tf
    - c110.02-cni.yml > creates several resources inside eks
    - c102-02-cluster-autoscaler-install.tf
    - c103-01-promtheus.tf
    - c103-03-promtheus-namespace.tf
    - c101-01-ebs-csi-datasources.tf
    - c100-02-metrics-server-install.tf

  ## EKS Public Node Groups files
    - c005-07-eks-node-group-public.tf
    - c005-05-securitygroups-eks.tf
    - Folder /private-key contains the key pair for Bastion and/or public node group - View Readme
    - Variables of Public and Private Node Groups are in the same files (c005-01-eks-variables.tf and ec2bastion.auto.tfvars)

  ## EKS Private Node Groups files
    - c005-08-eks-node-group-private.tf
    - Variables of Public and Private Node Groups are in the same files (c005-01-eks-variables.tf and ec2bastion.auto.tfvars)

  ## Terraform and EKS Outputs
    - c005-02-eks-outputs.tf
    - c100-03-metrics-server-outputs.tf
    - c101-05-ebs-csi-outputs.tf
    - c103-02-promtheus-outputs.tf
    - c110-05-cni-outputs.tf
    - c102-03-cluster-autoscaler-outputs.tf
  
  ## Bastion
    - Folder private-key contains the key pair for Bastion and/or public node group - View Readme
		- c004-01-ec2bastion-variables.tf
		- c004-02-ec2bastion-outputs.tf
		- c004-03-ec2bastion-securitygroups.tf
		- c004-04-ami-datasource.tf
		- c004-05-ec2bastion-instance.tf
		- c004-06-ec2bastion-elasticip.tf
		- c004-07-ec2bastion-provisioners.tf
    - ec2bastion.auto.tfvars