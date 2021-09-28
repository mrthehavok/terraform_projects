#------------------------------------------------------------------------------------------------
#
#                                  Variables for RDS.
#
#------------------------------------------------------------------------------------------------

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

