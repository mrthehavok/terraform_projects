provider "aws" {}

resource "aws_instance" "amazon_linux_from_terraform" {
    count = 2
    ami             =   "ami-07df274a488ca9195"
    instance_type   =   "t2.micro" 
    tags = {
         Name       =   "Created from Terraform"
         Project    =   "Terraform"
         }
}