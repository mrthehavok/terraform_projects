#------------------------------------------------------------------------------------------------
#
#                                  Variables for RDS.
#
#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------
#                                         Global variables
#------------------------------------------------------------------------------------------------
variable "environment" {
  default = "DEV"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
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
#                                         RDS variables
#------------------------------------------------------------------------------------------------
variable "ssm_password" {
  default = ""
}

variable "subnet_ids" {
  default = ""
}


variable "vpc_id" {
  default = ""
}


variable "engine" {
  default = "postgres"
}


variable "db_port" {
  default = 5432
}


variable "db_username" {
  default = "root"
}

variable "maintenance_window" {
  default = "Mon:00:00-Mon:03:00"
}

variable "backup_window" {
  default = "03:00-06:00"
}

variable "character_set" {
  default = "utf8mb4"
}