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

data "aws_ami" "latest_ubuntu" {
    owners      = ["099720109477"]
    most_recent = true
    filter {
      name  = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server*"]
    }
}

output "latest_ubuntu_ami_id" {
  value   = data.aws_ami.latest_ubuntu.id
}

output "latest_ubuntu_ami_name" {
  value   = data.aws_ami.latest_ubuntu.name
}

data "aws_ami" "latest_amazon_linux_ARM" {
    owners      = ["amazon"]
    most_recent = true
    filter {
      name  = "name"
      values = ["amzn2-ami-hvm-2.0*arm64*"]
    }
}

output "latest_amazon_ami_id" {
  value   = data.aws_ami.latest_amazon_linux_ARM.id
}

output "latest_amazon_ami_name" {
  value   = data.aws_ami.latest_amazon_linux_ARM.name
}

data "aws_ami" "latest_windows_2019" {
    owners      = ["amazon"]
    most_recent = true
    filter {
      name  = "name"
      values = ["Windows_Server-2019-English-Full-*"]
    }
}

output "latest_windows_ami_id" {
  value   = data.aws_ami.latest_windows_2019.id
}

output "latest_windows_ami_name" {
  value   = data.aws_ami.latest_windows_2019.name
}
