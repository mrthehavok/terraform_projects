#------------------------------------------------------------------------------------------------
#
#                             Output with user info
#
#------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------
#                                         Users
#------------------------------------------------------------------------------------------------

output "ARN_super" {
  value = module.iam_user_super.iam_user_arn
}

output "ARN_DB" {
  value = module.iam_user_db.iam_user_arn
}

output "ARN_dev1" {
  value = module.iam_user_dev1.iam_user_arn
}

output "ARN_dev2" {
  value = module.iam_user_dev2.iam_user_arn
}