output "alb_dns_name" {
  value= aws_lb.my-alb.dns_name  
}

output "target_group_arn"  {
  value = aws_lb_target_group.TG-ec2.arn
}


output "sg_alb_id" {
  value= aws_security_group.ALB-sg-allow-tcp-80-443-from-anywhere.id
}