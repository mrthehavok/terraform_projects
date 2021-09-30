#------------------------------------------------------------------------------------------------
#
#               Module for creating blue/green deployment and bastion in public subnets
#
#------------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------------

// Get latest AMI for bastion
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

#------------------------------------------------------------------------------------------------
#                                         Create blue/green deployment
#------------------------------------------------------------------------------------------------

module "asg_web" {
  source = "github.com/mrthehavok/terraform_modules/modules/aws_ec2_asg/"
  des_asg_size  = var.des_asg_size
  max_asg_size  = var.max_asg_size
  min_asg_size = var.min_asg_size
  subnet_id     = var.subnets
  vpc_id        = var.vpc_id
  common_tags = var.common_tags
}

#------------------------------------------------------------------------------------------------
#                                        Create bastion host.
#------------------------------------------------------------------------------------------------


resource "aws_security_group" "bastion_host" {
  name = "Bastion Security Group"
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge (var.common_tags , {Name = " ${var.common_tags["Environment"]} Bastion SG"})
}



module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "bastion-instance"

  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = (var.environment == "PROD" ? "t2.small" : "t2.micro")
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion_host.id]
  subnet_id              = var.subnets[0]

  tags = var.common_tags
}