#------------------------------------------------------------------------------------------------
#
#       Global variables for my project
#
#------------------------------------------------------------------------------------------------

provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "mrthehavok.test.cli"
    key    = "VPC_EC2/globalvars/terraform.tfstate"
    region = "eu-central-1"
  }
}

#------------------------------------------------------------------------------------------------

output "Project" {
  value = "VPC_EC2"
}

output "common_tags" {
  value = {
      Project   = "VPC_EC2"
      Created   = "By Terraform"
      Owner     = "idmitriev"
  }
}