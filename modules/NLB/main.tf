

resource "aws_security_group" "nlb_sg" {
  name        = "${terraform.workspace}-nlb-sg-zakaria"
  description = "Allow traffic of Network Load balancer using 3306 port"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${terraform.workspace}-nlb-sg-zakaria"
  }
}

resource "aws_security_group_rule" "nlb_sg_with_wordpress_ec2" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.nlb_sg.id
  source_security_group_id = var.public_wordpress_ec2_sg_id
}


resource "aws_lb_target_group" "nlb_target_group" {
  name     = "${terraform.workspace}-nlb-tg-zakaria"
  port     = 3306
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    port       = 3306
    healthy_threshold = 3
    unhealthy_threshold = 3
    # timeout = 10
    interval = 30
    protocol = "HTTP"
    # matcher = "200-299"
  }
}




resource "aws_lb_target_group_attachment" "nlb_target_group_attachment" {
  target_group_arn = aws_lb_target_group.nlb_target_group.arn
  target_id        = var.database_ec2_instance_id
  port             = 3306
}




resource "aws_lb" "private_nlb" {
  name               = "${terraform.workspace}-private-alb-db-zakaria"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.nlb_sg.id]
  subnets            = var.private_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "${terraform.workspace}-private-alb-database-zakaria"
  }
}

                                    # LISTENER INTERNAL Application Load Balancer 
resource "aws_lb_listener" "private_alb_listener" {
  load_balancer_arn = aws_lb.private_nlb.arn
  port = 3306
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.nlb_target_group.arn
  }
}