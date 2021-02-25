
                                    # Security Group for External Application Load Balancer 
resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id
  name = "${terraform.workspace}-alb-sg-zakaria"
  description = "Security Group for Application Load Balancer"

  ingress {
      from_port     = 80
      to_port       = 80
      protocol      = "tcp"
      cidr_blocks    = ["0.0.0.0/0"]
  }
  egress {
      from_port     = 0
      to_port       = 0
      protocol      = "-1"
      cidr_blocks    = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${terraform.workspace}-alb-sg-zakaria"
  }

}

                                    # External Application LOAD BALANCER
resource "aws_lb" "external_alb" {
  name = "${terraform.workspace}-external-alb-zakaria"
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.alb_sg.id]
  subnets = var.public_subnets

  tags = {
    Name = "${terraform.workspace}-external-alb-zakaria"
  }

}
    
                                    # TARGET GROUP of External Application Load Balancer 
resource "aws_lb_target_group" "external_alb_target_group" {
  name = "${terraform.workspace}-external-alb-tg-zakaria"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    port       = 80
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    interval = 10
    path = var.health_check_path
    protocol = "HTTP"
    matcher = "200-299"
  }
}

                                    # LISTENER External Application Load Balancer 
resource "aws_lb_listener" "external_alb_listener" {
  load_balancer_arn = aws_lb.external_alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.external_alb_target_group.arn
  }
}



