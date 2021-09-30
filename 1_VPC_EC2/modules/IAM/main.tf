#------------------------------------------------------------------------------------------------
#
#                            Module for user and group creation
#
#------------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------------
#                                         Users
#------------------------------------------------------------------------------------------------

module "iam_user_super" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 4.3"

  name          = var.root_user_name
  force_destroy = true
  pgp_key = "keybase:test"
  password_reset_required = false
}

module "iam_user_db" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 4.3"

  name          = var.db_admin_user_name
  force_destroy = true
  pgp_key = "keybase:test"
  password_reset_required = false
}

module "iam_user_dev1" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 4.3"

  name          = var.db_dev_user_name1
  force_destroy = true
  pgp_key = "keybase:test"
  password_reset_required = false
}

module "iam_user_dev2" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 4.3"

  name          = var.db_dev_user_name2
  force_destroy = true
  pgp_key = "keybase:test"
  password_reset_required = false
}

#------------------------------------------------------------------------------------------------
#                                         Groups
#------------------------------------------------------------------------------------------------

// Create  group with full permissions for root user.
module "iam_group_superadmin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "~> 4.3"

  name = var.root_group_name

  group_users = [
    var.root_user_name 
  ]

  attach_iam_self_management_policy = true

  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]
}

// Create  group with db full permissions for DBA
module "iam_group_db_admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "~> 4.3"

  name = var.db_admin_group_name

  group_users = [
    var.db_admin_user_name 
  ]

  attach_iam_self_management_policy = true

  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
  ]
}
// Create  group with db RO permissions for DB developers
module "iam_group_db_dev" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "~> 4.3"

  name = var.db_dev_group_name

  group_users = [
    var.db_dev_user_name1,
    var.db_dev_user_name2
  ]

  attach_iam_self_management_policy = true

  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess",
  ]
}