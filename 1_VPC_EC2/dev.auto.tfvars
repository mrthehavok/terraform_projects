#------------------------------------------------------------------------------------------------
#                                         Global variables
#------------------------------------------------------------------------------------------------
region_name         = "eu-west-1"
#bucket_name         = "mrthehavok.test.cli"
project_name        = "Alpha"
#bucket_region       = "eu-central-1"

common_tags         = {
                        Project     = "Alpha"
                        Created     = "By Terraform"
                        Owner       = "idmitriev"
                        Environment = "Development"
                        }
company_name        = "HashiCorp"                        
environment         = "DEV"


#------------------------------------------------------------------------------------------------
#                                         Network variables
#------------------------------------------------------------------------------------------------

cidr_block          =   "10.0.0.0/16"  
azs                 =   ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
private_subnets     =   []
public_subnets      =   ["10.0.11.0/24", "10.0.12.0/24"]
database_subnets    =   ["10.0.21.0/24","10.0.22.0/24"]