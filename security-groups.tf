
resource "aws_security_group" "sg" {
  name_prefix = var.cluster-prefix
  vpc_id      = module.vpc.vpc_id

  # SSH access from the VPC
  ingress {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      self = "true"
  }

  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

