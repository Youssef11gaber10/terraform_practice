# launch tempalte variables
variable "project_name" {
  type = string
}
variable "vpc_id" {
    type = string
}
variable "instance_type" {
    type = string
    default = "t3.micro"
  
}

variable "pair_key_name" {
    type = string
    default = "key-private-ec2"
}


# ASG variables
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

variable "list_public_subnets_ids_ASG" {
    type = list(string)
}

variable "TG-ec2_arn" {
    type = string
}

variable "sg_alb_id" {
  type= string
}