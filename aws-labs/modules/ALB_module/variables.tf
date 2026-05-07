
variable "vpc_id" {
  type = string
}

variable "project_name" {
    type = string
  
}

variable "list_public_subnets_ids_ALB" {
  type = list(string)
}