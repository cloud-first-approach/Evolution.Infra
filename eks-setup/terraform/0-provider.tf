terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  profile = "Yahoo Free"
}

variable "cluster_name" {
  default = "eks-demo"
}

variable "cluster_version" {
  default = "1.22"
}
