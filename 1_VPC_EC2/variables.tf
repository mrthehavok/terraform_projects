variable "environment" {
  default = "DEV"
}

variable "common_tags" {
    default = {
                        Project     = "Alpha"
                        Created     = "By Terraform"
                        Owner       = "idmitriev"
                        Environment = "Development"
                        
    }
}