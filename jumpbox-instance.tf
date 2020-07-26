provider "aws" {
        access_key = var.access_key
        secret_key = var.secret_key
        region = var.region
        alias  = "configure"
}

#resource "aws_key_pair" "publickey" {
#  key_name   = "publickey"
#  public_key = file("/Users/sravan/Alpha/terraform/eks-cluster/sravan-eks-apne1.pem")
#}

resource "aws_instance" "jumpbox" {
  ami           = module.eks.workers_default_ami_id
  instance_type = var.instance_type
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.sg.id]
  associate_public_ip_address = true
  key_name = "sravan-eks-apne1"

  connection {
    type  = "ssh"
    host  = aws_instance.jumpbox.public_ip
    user  = var.jumpbox_username
    port  = 22
    agent = true
    private_key = file("/Users/sravan/Alpha/terraform/eks-cluster/sravan-eks-apne1.pem")
    timeout     = "1m"
  }

  provisioner "remote-exec" {
    inline=[
      "sudo yum -y install bind-utils",
      "sudo yum -y install telnet",
      "sudo yum -y install git",
      "sudo yum -y install python-pip",
      "sudo pip install ansible",
      "curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash",
      "curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.11/2020-07-08/bin/linux/amd64/kubectl | mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl | chmod a+x ./kubectl && echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc",
      "git clone https://github.com/dommarajusravan/confluent-operator.git /home/ec2-user/confluent-operator"
    ]
  }

#  connection {
#    user=var.jumpbox_username
#    #private_key=file(var.public_key)
#    host = aws_instance.jumpbox.public_ip
#  }
}
