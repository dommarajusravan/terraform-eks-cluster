locals {
  cluster_name = "${var.cluster-prefix}-eks-${random_string.suffix.result}" 
  create_jumpbox = true
  create_vpc_sg = true
  create_eks = true
}


variable "region" {
  default     = "ap-northeast-1"
  description = "AWS region"
}

variable "access_key" {
  default = "AKIA2EUNEUMB2A6KFA2Z"
}
variable "secret_key" {
  default = "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"
}

variable "jumpbox_username" {
  default = "ec2-user"
}

variable "public_key" {
  default = "sravan-eks-apne1.pem"
}

variable "cluster-prefix" {
  default = "Sravan"
}

variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default = "ami-0a243dbef00e96192"
}

variable "instance_type" {
  description = "type for aws EC2 instance"
  default = "m3.medium"
}

variable "eks-cluster-version" {
  default = "1.15"
}

variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "172.33.0.0/16"
}

variable "cidr_subnets" {
  description = "CIDR block for the subnet"
  type = list(string)
  default = ["172.33.0.0/20", "172.33.16.0/20", "172.33.32.0/20"]
}


