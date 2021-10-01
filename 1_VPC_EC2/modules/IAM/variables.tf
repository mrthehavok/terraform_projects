#------------------------------------------------------------------------------------------------
#
#                                  Variables for username and group name.
#
#------------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------------
#                                         Users
#------------------------------------------------------------------------------------------------

variable "root_user_name" {
  default = "superuser"
}

variable "db_admin_user_name" {
  default = "db_admin"
}

variable "db_dev_user_name1" {
  default = "db_developer1"
}

variable "db_dev_user_name2" {
  default = "db_developer2"
}

#------------------------------------------------------------------------------------------------
#                                         Groups
#------------------------------------------------------------------------------------------------

variable "root_group_name" {
  default = "superadmins"
}

variable "db_admin_group_name" {
  default = "dba"
}

variable "db_dev_group_name" {
  default = "db_developers"
}

