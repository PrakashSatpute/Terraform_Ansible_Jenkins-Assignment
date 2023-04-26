#VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"
}

# Create ALB
resource "aws_alb" "alb" {  
      name  = "my-alb"
  load_balancer_type = "application"
  subnets  = ["subnet-02c0614a61baa4a5c", "subnet-00fc263c00e6637b0"]
  security_groups = ["sg-05423f57ef1f9952b"]
  internal  = false
  tags = local.common_tags
 
}

# Create ALB listener
resource "aws_alb_listener" "alb-listener" {  
  load_balancer_arn = "${aws_alb.alb.arn}"  
  port              = "80"  
  protocol          = "HTTP"
  
  default_action {    
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
  }
 }
}

# Create listener rule to forward /jenkins towards Jenkins EC2 instance
resource "aws_alb_listener_rule" "listener-rule-jenkins" {
  depends_on   = [aws_alb_target_group.jenkins-tg]  
  listener_arn = "${aws_alb_listener.alb-listener.arn}"  
  action {    
    type             = "forward"    
    target_group_arn = "${aws_alb_target_group.jenkins-tg.id}"  
  }   
  condition {
    path_pattern {
      values = ["/jenkins/*","/jenkins"]
    }
  }
}

# Create listener rule to forward /app towards APP EC2 instance
resource "aws_alb_listener_rule" "listener_rule_app" {
  depends_on   = [aws_alb_target_group.app-tg]  
  listener_arn = "${aws_alb_listener.alb-listener.arn}"  
  action {    
    type             = "forward"    
    target_group_arn = "${aws_alb_target_group.app-tg.id}"  
  }   
  condition {
    path_pattern {
      values = ["/app/*", "/app"]
    }
  }
}

# Create Jenkins Target group for EC2 Jenkins instance
resource "aws_alb_target_group" "jenkins-tg" {  
   name = "jenkins-tg"  
  port     = "8080"  
  protocol = "HTTP"  
  vpc_id   = "vpc-0c80cd3cdf19d2442"  
  tags = local.common_tags
  health_check {
    path = "/jenkins"
    port = 8080
    healthy_threshold = 6
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200-499"  
  }
}
 
# Create App Target Group for EC2 App instance
resource "aws_alb_target_group" "app-tg" {  
 name_prefix = "app-tg" 
  port     = "8080"
  protocol = "HTTP"  
  vpc_id   = "vpc-0c80cd3cdf19d2442" 
  tags  = local.common_tags
  health_check {
    path = "/app"
    port = 8080
    healthy_threshold = 6
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200-499"  
  }
}

# Attach Jenkins EC2 to Jenkins Target group
resource "aws_lb_target_group_attachment" "jenkins" {
  depends_on   = [aws_alb_target_group.jenkins-tg]  
  target_group_arn = "${aws_alb_target_group.jenkins-tg.arn}"
  target_id        = aws_instance.jenkins.id
  port             = "8080"
}

# Attach App EC2 to App Target group
resource "aws_lb_target_group_attachment" "app" {
  depends_on   = [aws_alb_target_group.app-tg]  
  target_group_arn = "${aws_alb_target_group.app-tg.arn}"
  target_id        = aws_instance.app.id
  port             = "8080"
}
