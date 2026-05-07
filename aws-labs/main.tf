# module "network" {
#   source = "./modules/network_module"

# subnet_variables_list = var.subnet_variables_list # this take its value from .tfvars
# vpc_cidr = var.vpc_cidr # this take its value from .tfvars
# region = var.region # this take its value from .tfvars

# }

# module "asg" {
#   source = "./modules/ASG_module"

# project_name = var.project_name # this take its value from .tfvars
# # vpc_id = var.vpc_id
# vpc_id = module.network.NM_vpc_id
# instance_type = var.instance_type # this take its value from .tfvars
# pair_key_name = var.pair_key_name # this take its value from .tfvars
# asg_desired = var.asg_desired # this take its value from .tfvars
# asg_min = var.asg_min # this take its value from .tfvars
# asg_max = var.asg_max # this take its value from .tfvars
# list_public_subnets_ids_ASG = [ module.network.NM_subnets["public_subnet_1"].id, 
#                                 module.network.NM_subnets["public_subnet_2"].id,
#                                 module.network.NM_subnets["public_subnet_3"].id
#                               ]# this take its value from .tfvars # can't take it from .tfvars 
# TG-ec2_arn = module.alb.target_group_arn
# sg_alb_id = module.alb.sg_alb_id
# }


# module "alb" {
#   source = "./modules/ALB_module"

# project_name = var.project_name # this take its value from .tfvars
# # vpc_id = var.vpc_id
# vpc_id = module.network.NM_vpc_id
# # list_public_subnets_ids_ALB = var.list_public_subnets_ids_ALB # this take its value from .tfvars
# list_public_subnets_ids_ALB = [ module.network.NM_subnets["public_subnet_1"].id, 
#                                 module.network.NM_subnets["public_subnet_2"].id,
#                                 module.network.NM_subnets["public_subnet_3"].id
#                               ]
  
# } 


#-----------------------------------
#lab-2-route

module "dynamoDB" {
  source = "./modules/lab-2-route/dyanamo_DB_module"
  partition_key = var.partition_key
  
}

module "iam_roles" {
  source = "./modules/lab-2-route/iam_module"

  users_table_arn = module.dynamoDB.users_table_arn
  
}


module "lambda" {
  source = "./modules/lab-2-route/lambda_module"

  DynamoDB_write_role_arn = module.iam_roles.DynamoDB_write_role_arn
  DynamoDB_read_role_arn = module.iam_roles.DynamoDB_read_role_arn
  DynamoDB_table_name = module.dynamoDB.DynamoDB_table_name
  
}

module "api-gw" {
  source = "./modules/lab-2-route/api_GW_module"
  register_user_lambda_invoke_arn = module.lambda.register_user_lambda_invoke_arn
  get_users_lambda_invoke_arn = module.lambda.get_users_lambda_invoke_arn
  register_user_lambda_func_name = module.lambda.register_user_lambda_func_name
  get_users_lambda_func_name = module.lambda.get_users_lambda_func_name
  frontend_s3_origin = module.s3.s3_website_endpoint

}


module "s3" {
  source = "./modules/lab-2-route/s3_module"

  bucket_name = var.bucket_name
  
}


