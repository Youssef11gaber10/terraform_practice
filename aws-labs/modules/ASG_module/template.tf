# i will make tempalte to be used  by ASG 


# get ami of amazon linux 2

data "aws_ami" "amazon_linux_23" { # so i will fetch data of ami 
    # most_recent = true # get the most recent image from this ami
    owners      = ["amazon"] # owner of this ami was amazon can be self (my-ami's) or amazon(general ami's)

    filter { # filter them by name
        name   = "image-id"
        # values = ["amzn2-ami-hvm-*-x86_64-gp2"] # name of family of this
        values = ["ami-059f32cf6eecf0ef9"]
    }

    # filter {
    #   name = "state"
    #   values = [ "available" ]
    # }
}
#create SG for ec2 instance template 

# resource "aws_security_group" "sg-ec2-instance-allow-tcp-80-from-anywhere" { # suppose altered 80 from sg_of_alb only
#     name   = "sg_ec2_instance_allow_tcp_80_from_anywhere"
#     vpc_id=var.vpc_id # this sg will be in which vpc
#     ingress {          # come to me (anywhere 0.0.0.0/0)
#         from_port   = 80 # here from & to to define range of ports 
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"] # anywhere can connect to me on port 80 # suppose altered 80 from sg_of_alb only
#     }
#     egress { # this is mandatory in terraform
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#     }
#     tags = {
#         Name = "sg_ec2_instance_allow_tcp_80_from_anywhere"
#     }
# }

resource "aws_security_group" "sg-ec2-instance-allow-tcp-80-from-sg-alb" { # suppose altered 80 from sg_of_alb only
    name   = "sg_ec2_instance_allow_tcp_80_from_sg-alb"
    vpc_id=var.vpc_id # this sg will be in which vpc
    ingress {          # come to me (anywhere 0.0.0.0/0)
        from_port   = 80 # here from & to to define range of ports 
        to_port     = 80
        protocol    = "tcp"
        #this sg of alb exist in module alb , not in my module so can't refer to it , so send the id of sg_of_alb as variable or test with 0.0.0.0/0
        # cidr_blocks = [aws_security_group.ALB-sg-allow-tcp-80-443-from-anywhere.id] # anywhere can connect to me on port 80 # suppose altered 80 from sg_of_alb only
        # cidr_blocks = ["0.0.0.0/0"]
        security_groups = [var.sg_alb_id]
    }
    ingress  {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress { # this is mandatory in terraform
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "sg_ec2_instance_allow_tcp_80_from_sg-alb"
    }
}

# start create template 
resource "aws_launch_template" "ec2-nginx-lt" {
  name_prefix   = "${var.project_name}ec2-nginx-template"
  description = "lanunch template for ASG"
  image_id      = data.aws_ami.amazon_linux_23.id
  instance_type = var.instance_type
  key_name = var.pair_key_name

# networking # will define subnets in ASG to not be static in one az 

# networking -> make template have public ip

network_interfaces {
  associate_public_ip_address = true 
  delete_on_termination = true
  security_groups = [aws_security_group.sg-ec2-instance-allow-tcp-80-from-sg-alb.id]
}


#storage 
block_device_mappings {
  device_name = "/dev/xvda"
  ebs{
    volume_size = 20
    volume_type = "gp2"
    # iops = 3000
    # throughput = 125
    delete_on_termination = true
  }

}

# user data 
user_data = base64encode(<<-EOF
#!/bin/bash

 dnf update -y
 dnf install nginx -y

 systemctl start nginx
 systemctl enable nginx

HOSTNAME=$(hostname)

cat > /usr/share/nginx/html/index.html <<EOF2
<!DOCTYPE html>
<html>
<body>
<h1>hello ec2 youssef $HOSTNAME</h1>
</body>
</html>
EOF2

EOF
)










}