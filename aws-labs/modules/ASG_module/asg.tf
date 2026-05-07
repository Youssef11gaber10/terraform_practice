resource "aws_autoscaling_group" "ASG-EC2" {
  name= "${var.project_name}-ASG-EC2"
  #capacity
  desired_capacity = var.asg_desired
  min_size = var.asg_min
  max_size = var.asg_max

 #subnets 
 vpc_zone_identifier = var.list_public_subnets_ids_ASG # list of public subnets ids

  #launch template
  launch_template {
    id = aws_launch_template.ec2-nginx-lt.id
    version = "$Latest" # choose latest version
  }

  # alb attach tg to this asg later
#   target_group_arns = [aws_lb_target_group.TG-ec2.arn] # wire asg to alb tg # here this in module alb so can't refer to it , ask it as variable and make main.tf as mid layer take output from alb module and pass it as variable to asg module
target_group_arns = [var.TG-ec2_arn]
  #wait for instance to pass alb health check before making it available
  health_check_type = "ELB" # use ec2 until alb is ready
  health_check_grace_period = 300 # seconds before first check

  #tags
  tag  {
      key = "Name"
      value = "${var.project_name}-ASG-EC2-instance"
      propagate_at_launch = true # propagate to all instances
      }

    lifecycle {
      create_before_destroy = true # if you destroy ec2 instnace before destroying the asg you will create new ec2 instance
      #ignore desired capacity changes caused by scaling policies
      ignore_changes = [ desired_capacity ]
    }
  
}
#autoscaling policies
resource "aws_autoscaling_policy" "cpu_tracking" {
  name = "cpu-tracking"
  autoscaling_group_name = aws_autoscaling_group.ASG-EC2.name
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50
  }
 
  
}