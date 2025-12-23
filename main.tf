terraform {
    required_version = ">= 1.5.7"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
    backend "s3" {
    bucket = "infra-modules-tf-state-dev-runners-infra"
    key    = "eks-karpenter/terraform.tfstate"
    region = "us-east-1"
}
}
module "vpc"{
    source = "./test-modules"
    vpc_name = "test-vpc"
    cidr_block = "10.0.0.0/16"
    tags =  {
        Name = "test-vpc"
    }
}