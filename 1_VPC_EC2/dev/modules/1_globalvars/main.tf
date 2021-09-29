#------------------------------------------------------------------------------------------------
#
#                                  Global variables for my project
#
#------------------------------------------------------------------------------------------------

terraform {
  backend "s3" {
    bucket = var.bucket_name
    key    = "${var.project_name}/globalvars/terraform.tfstate"
    region = var.bucket_region
  }
}

#------------------------------------------------------------------------------------------------

output "company_name" {
  value = "CMP inc"
}

output "env" {
  value = "DEV"
}

output "common_tags" {
  value = {
      Project     = "VPC_EC2"
      Created     = "By Terraform"
      Owner       = "idmitriev"
      Environment = "Development"
  }
}

output "region_name" {
  value = var.region_name
}