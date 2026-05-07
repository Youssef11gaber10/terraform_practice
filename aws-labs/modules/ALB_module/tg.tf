# create the TG 
resource "aws_lb_target_group" "TG-ec2" {
    name     = "${var.project_name}-TG-ec2"
    target_type = "instance"
    protocol = "HTTP"
    port     = 80
    vpc_id   = var.vpc_id

    # health check
    health_check {
        enabled = true
        path = "/"
        protocol = "HTTP"
        matcher = "200"
        interval = 15
        timeout = 3
        healthy_threshold = 2
        unhealthy_threshold = 2
    }

    tags = {
        Name = "${var.project_name}-TG-ec2"
    }
  
}

# health