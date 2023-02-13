# Terraform Settings Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.14"
     }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.11"
    }
    http = {
      source = "hashicorp/http"
      version= "~> 3.2.1"
    }
    helm = {
      source = "hashicorp/helm"
      #version = "2.5.1"
      version = "~> 2.5"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }       
  }
 # Adding Backend as S3 for Remote State Storage
 backend "s3" {
   bucket = "tfstate-prueba"
   key    = "dev/cluster/terraform.tfstate"
   region = "us-west-2" 

   # For State Locking
   dynamodb_table = "dev-ekscluster-test"    
 }
}

# Terraform Provider Block
provider "aws" {
  region = var.aws_region
}