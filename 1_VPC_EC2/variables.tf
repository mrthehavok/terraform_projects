#------------------------------------------------------------------------------------------------
#                                         Global variables
#------------------------------------------------------------------------------------------------

variable "environment" {
  default = "DEV"
}

variable "region_name" {
  default = "eu-west-1"
}

variable "common_tags" {
    default = {
                        Project     = "Alpha"
                        Created     = "By Terraform"
                        Owner       = "idmitriev"
                        Environment = "Development"
                        
    }
}

#------------------------------------------------------------------------------------------------
#                                         Network variables
#------------------------------------------------------------------------------------------------

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "azs" {
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "private_subnets" {
  default = ["10.0.1.0/24"]
}

variable "public_subnets" {
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}


variable "database_subnets" {
  default = ["10.0.21.0/24","10.0.22.0/24"]
}

#------------------------------------------------------------------------------------------------
#                                         Servers variables
#------------------------------------------------------------------------------------------------

variable "min_asg_size" {
  default = 1
}

variable "max_asg_size" {
  default = 3
}

variable "des_asg_size" {
  default = 2
}

variable "vpc_id" {
  default = ""
}

variable "subnets" {
  default = ""
}

variable "key_name" {
  default = "idmitriev-key-ireland.pem"
}
