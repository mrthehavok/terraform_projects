#------------------------------------------------------------------------------------------------
#
#                                Create servers in public subnets
#
#------------------------------------------------------------------------------------------------

provider "aws" {
  region = local.region_name
}

terraform {
  backend "s3" {
    bucket  =   "mrthehavok.test.cli"
    key     =   "VPC_EC2/dev/vpc/public/terraform.tfstate"
    region  =   "eu-central-1"
  }
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "mrthehavok.test.cli"
    key    = "VPC_EC2/globalvars/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "mrthehavok.test.cli"
    key    = "VPC_EC2/dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

locals {
  company_name  = data.terraform_remote_state.global.outputs.company_name
  region_name   = data.terraform_remote_state.global.outputs.region_name
  common_tags   = data.terraform_remote_state.global.outputs.common_tags
  subnets       = data.terraform_remote_state.network.outputs.subnet_id
  vpc_id        = data.terraform_remote_state.network.outputs.vpc_id
}

#------------------------------------------------------------------------------------------------


module "asg_web" {
  source = "github.com/mrthehavok/terraform_modules/modules/aws_ec2_asg/"
  des_asg_size  = var.des_asg_size
  max_asg_size  = var.max_asg_size
  min_asg_size = var.min_asg_size
  subnet_id     = local.subnets
  vpc_id        = local.vpc_id
  common_tags = local.common_tags
}

#------------------------------------------------------------------------------------------------

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


resource "aws_security_group" "bastion_host" {
  name = "Bastion Security Group"
  vpc_id = local.vpc_id
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

  tags = merge (local.common_tags , {Name = "Bastion SG"})
}



module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "bastion-instance"

  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = "idmitriev-key-ireland.pem"
  vpc_security_group_ids = [aws_security_group.bastion_host.id]
  subnet_id              = local.subnets[0]

  tags = local.common_tags
}