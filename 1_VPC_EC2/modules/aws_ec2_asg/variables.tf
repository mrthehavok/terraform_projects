#------------------------------------------------------------------------------------------------
#
#                                  Variables for module
#
#------------------------------------------------------------------------------------------------

variable "min_asg_size" {
  default = 1
}


variable "max_asg_size" {
  default = 2
}


variable "des_asg_size" {
  default = 1
}


variable "subnet_id" {
  default = [
      "subnet-0fed20787957988b5",
      "subnet-0dea5aa533ddfa4a2"
  ]
}

variable "allow_ports" {
  description = "List of ports to open to server "
  default = ["80" , "443" ]
}

variable "common_tags" {
  default = {
      Project   = "VPC_EC2" 
      Created   = "By Terraform" 
      Owner     = "idmitriev"
  }
}

variable "vpc_id" {
  default = "vpc-00df54b01ad1ff9b6"
}