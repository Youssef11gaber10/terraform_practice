subnet_variables_list = [ {
    name = "private_subnet_1", # private or public & use this as condition also not just in name
    subnet_cidr = "10.100.1.0/24", # 
    AZ_letters = "a",# region +(a,b,c)
    type = "private" # private or public # to make condition of allow public ip or not
  },
  {
    name = "private_subnet_2", 
    subnet_cidr = "10.100.2.0/24", 
    AZ_letters = "b",
    type = "private" 
  },
  {
    name = "private_subnet_3", 
    subnet_cidr = "10.100.3.0/24", 
    AZ_letters = "c",
    type = "private"
  },
  {
    name = "public_subnet_1",
    subnet_cidr = "10.100.4.0/24", 
    AZ_letters = "a",
    type = "public" 
  },
  {
    name = "public_subnet_2", 
    subnet_cidr = "10.100.5.0/24", 
    AZ_letters = "b",
    type = "public" 
  },
  {
    name = "public_subnet_3", 
    subnet_cidr = "10.100.6.0/24", 
    AZ_letters = "c",
    type = "public"
  }
]


region = "eu-north-1"
vpc_cidr = "10.100.0.0/16"

# -----
#variable of asg module
#template
project_name = "terraform-aws-labs"
instance_type = "t3.micro"
pair_key_name = "key-private-ec2"
# vpc_id= module.network.NM_vpc_id
asg_desired = 2
asg_min = 2
asg_max = 4
# list_public_subnets_ids_ASG = [ module.network.NM_subnets["public_subnet_1"].id, 
#                                 module.network.NM_subnets["public_subnet_2"].id,
#                                 module.network.NM_subnets["public_subnet_3"].id
#                               ]

# # ---------

# list_public_subnets_ids_ALB = [ module.network.NM_subnets["public_subnet_1"].id, 
#                                 module.network.NM_subnets["public_subnet_2"].id,
#                                 module.network.NM_subnets["public_subnet_3"].id
#                               ]


#---------------------------------------------------------------------------------------------
#variable of dyanamoDB module
partition_key = "email"

#varaible of s3 bucket name
bucket_name = "frontend-bucket-terraform-route-lab2"