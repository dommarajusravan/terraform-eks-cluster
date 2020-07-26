
#provider "aws" {
#  version = ">= 2.28.1"
#  region  = var.region
#}

data "aws_availability_zones" "available" {}


resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.6.0"

  name                 		= "${var.cluster-prefix}-vpc"
  cidr                 		= var.cidr_vpc
  azs                  		= data.aws_availability_zones.available.names
  public_subnets      		= var.cidr_subnets
  map_public_ip_on_launch	= true
  enable_dns_hostnames		= true
  enable_dns_support   		= true
}

