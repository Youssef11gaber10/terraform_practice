# create SG of ALB allow 80,443 from any where 
resource "aws_security_group" "ALB-sg-allow-tcp-80-443-from-anywhere" {
    name   = "ALB-sg-allow-tcp-80-443-from-anywhere"
    vpc_id=var.vpc_id # this sg will be in which vpc
    ingress {          # come to me (anywhere 0.0.0.0/0)
        from_port   = 80 # here from & to to define range of ports
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # anywhere can connect to me on port 80
    }
    ingress {          # come to me (anywhere 0.0.0.0/0)
        from_port   = 443 # here from & to to define range of ports
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # anywhere can connect to me on port 443
    }
    egress { # this is mandatory in terraform
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "ALB-sg-allow-tcp-80-443-from-anywhere"
    }
}
# create ALB
resource "aws_lb" "my-alb" {
  name = "${var.project_name}-my-alb"
  internal = false # internet facing
  load_balancer_type = "application"
  security_groups = [aws_security_group.ALB-sg-allow-tcp-80-443-from-anywhere.id]
#   subnets = [var.public_subnet_1_id, var.public_subnet_2_id, var.public_subnet_3_id]
  subnets = var.list_public_subnets_ids_ALB # one per az

  enable_deletion_protection = false # make it true on production

  tags = {
    Name = "${var.project_name}-my-alb"
  }
}
# create listener for ALB on TG 
resource "aws_lb_listener" "listen_on_TG_on_http80" {
  load_balancer_arn = aws_lb.my-alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.TG-ec2.arn
  }
}