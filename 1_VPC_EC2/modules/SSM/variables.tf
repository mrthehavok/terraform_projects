#------------------------------------------------------------------------------------------------
#
#                                  Variables for password generation
#
#------------------------------------------------------------------------------------------------

variable "password_length" {
  default = "16"
}
variable "environment" {
  default = "TEST"
}

variable "common_tags" {
    default = {
                        Project     = "Alpha"
                        Created     = "By Terraform"
                        Owner       = "idmitriev"
                        Environment = "Development"
                        
    }
}