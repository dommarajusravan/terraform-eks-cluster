provider "aws" {
        access_key = var.access_key
        secret_key = var.secret_key
        region = var.region
}

module "eks" {
  create_eks = local.create_eks

  source       			= "terraform-aws-modules/eks/aws"
  cluster_name			= local.cluster_name
  cluster_version 		= var.eks-cluster-version

  subnets      			= module.vpc.public_subnets
  vpc_id 			= module.vpc.vpc_id
#  cluster_security_group_id	= aws_security_group.sg.id
  cluster_iam_role_name		= "eks-ServiceRole" 
  manage_cluster_iam_resources	= false
  manage_worker_iam_resources	= true

}

provider "kubernetes" {
  host                   = element(concat(data.aws_eks_cluster.cluster[*].endpoint, list("")), 0)
  cluster_ca_certificate = base64decode(element(concat(data.aws_eks_cluster.cluster[*].certificate_authority.0.data, list("")), 0))
  token                  = element(concat(data.aws_eks_cluster_auth.cluster[*].token, list("")), 0)
  load_config_file       = false
  config_path 		 = "kubeconfig_${local.cluster_name}"
}

data "aws_eks_cluster" "cluster" {
  count = local.create_eks ? 1 : 0
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  count = local.create_eks ? 1 : 0
  name = module.eks.cluster_id
}

resource "aws_eks_node_group" "workers" {
  count = local.create_eks ? 1 : 0

  cluster_name	= local.cluster_name
  node_group_name = "sravan-nodegroup"
  node_role_arn = module.eks.worker_iam_role_arn
  subnet_ids = module.vpc.public_subnets
  disk_size = 50
  instance_types = ["m5.xlarge"]

  scaling_config {
    desired_size = 12
    max_size     = 12
    min_size     = 12
  }  

  remote_access {
    ec2_ssh_key = "sravan-eks-apne1"
    source_security_group_ids = [aws_security_group.sg.id]
  }
}
