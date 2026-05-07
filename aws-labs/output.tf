output "api_gw_endpoint" {
  value = module.api-gw.api_gw_endpoint
}


output "register_endpoint" {
  value = "${module.api-gw.api_gw_endpoint}register"   
  }


output "get_users_endpoint" {
  value = "${module.api-gw.api_gw_endpoint}users"
  }


output "s3_website_endpoint" {
  value = module.s3.s3_website_endpoint
}