#----------------------------------------------------------
# My Terraform
#
# Find Latest AMI id of:
#    - Ubuntu 20.04
#    - Amazon Linux 2 ARM
#    - Windows Server 2019 Base
#
# Made by Ilya Dmitriev
#-----------------------------------------------------------


provider "aws" {}

resource "aws_instance" "amazon_linux" {
    count = 2
    ami             =   data.aws_ami.latest_amazon_linux_ARM.id
    instance_type   =   "t4g.micro" 
    tags = {
      Name      = "Amazon Server"
      Project   = "Terraform"
      Created   = "By Terraform"
      ami       = "Using latest ${data.aws_ami.latest_amazon_linux_ARM.name}"
    }
}

resource "aws_instance" "ubuntu" {
    count = 2
    ami             =   data.aws_ami.latest_ubuntu.id
    instance_type   =   "t2.micro" 
    tags = {
      Name      = "Ubuntu Server"
      Project   = "Terraform"
      Created   = "By Terraform"
      ami       = "Using latest ${data.aws_ami.latest_ubuntu.name}"
    }
}

resource "aws_instance" "windows_2019" {
    count = 1
    ami             =   data.aws_ami.latest_windows_2019.id
    instance_type   =   "t2.micro" 
    tags = {
      Name      = "Windows Server 2019"
      Project   = "Terraform"
      Created   = "By Terraform"
      ami       = "Using latest ${data.aws_ami.latest_windows_2019.name}"
    }
}

resource "aws_security_group" "Server_Terraform" {
  name        = "Server Terraform SecGroup"
  description = "For Servers created from terraform"

    ingress   {
      description      = "https from Terraform"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress  {
      description      = "ssh from Terraform"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  

    egress  {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  

  tags = {
    Name = "For Server"
    Project = "Terraform"
  }
}