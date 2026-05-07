variable "region" {
  type = string
  default = "eu-north-1"
}

variable "vpc_cidr" {
  type = string
  default = "10.100.0.0/16"
}

variable "subnet_variables_list" {
  type = list(object({
    name = string, # private-subnet1 or public-subnet1 , private-subnet2 or public-subnet2
    subnet_cidr = string, # 
    AZ_letters = string,# region +(a,b,c)
    type = string # private or public # to make condition of allow public ip or not
  }))
}


# -----
#variable of asg module
#template
variable "project_name" {
  type = string
  default = "terraform-aws-labs"
}
# variable "vpc_id" { # take take it from network module in main.tf not from .tfvars
  
# }

variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "pair_key_name" {
  type = string
  default = "key-private-ec2"
}
#asg
variable "asg_desired" {
  type = number
  default = 2
}
variable "asg_min" {
  type = number
  default = 2
}
variable "asg_max" {
  type = number
  default = 4
  
}


# take take it from network module in main.tf not from .tfvars
# variable "list_public_subnets_ids_ASG" {
#   type = list(string)
# }


# #alb
# #some common variable no need to define it again
# variable "list_public_subnets_ids_ALB" {
#   type = list(string)
# }


#---------------------------
variable "partition_key" {
    type = string
}

# --------------
variable "bucket_name" {
    type = string
  
}