#------------------------------------------------------------------------------------------------
#
#                            Module for password generation
#
#------------------------------------------------------------------------------------------------

// Generate Password
resource "random_string" "rds_password" {
  length           = var.password_length
  special          = true
  override_special = "!#$&"
}

// Store Password in SSM Parameter Store
resource "aws_ssm_parameter" "rds_password" {
  name        = "/${var.environment}/RDS"
  description = "Master Password for RDS "
  type        = "SecureString"
  value       = random_string.rds_password.result
  tags        = var.common_tags
}


// Get Password from SSM Parameter Store
data "aws_ssm_parameter" "rds_password" {
  name       = "/${var.environment}/RDS"
  depends_on = [aws_ssm_parameter.rds_password]
}