#------------------------------------------------------------------------------------------------
#
#                                      Variables for ASG size
#
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

variable "subnet_id" {
  default = ""
}

variable "common_tags" {
    default = {
                        Project     = "Alpha"
                        Created     = "By Terraform"
                        Owner       = "idmitriev"
                        Environment = "Development"
                        
    }
}

variable "key_name" {
  default = "idmitriev-key-ireland.pem"
}

variable "environment" {
  default = "DEV"
}
