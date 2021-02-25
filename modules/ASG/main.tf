
resource "aws_security_group" "public_ec2_sg" {
  vpc_id = var.vpc_id
  name = "${terraform.workspace}-public-ec2-sg-zakaria"
  description = "Public facing EC2s Security Group"

  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks  = [var.external_alb_sg_id]
  # }

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${terraform.workspace}-public-ec2-sg-zakaria"
  }
}


resource "aws_security_group_rule" "public_ec2_sg_with_external_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.public_ec2_sg.id
  source_security_group_id = var.external_alb_sg_id
}



data "template_file" "wordpress_user_data" {
  template = "${file("${path.module}/wordpress.tpl")}"
  vars = {
    host = "${var.internal_nlb_dns_name}"
  }
}

resource "aws_launch_configuration" "wp_ec2_lc" {
  name_prefix   = "${terraform.workspace}-wp-ec2-lc-zakaria"
  image_id      = var.launch_template_ami
  instance_type = var.launch_template_instance_type
  key_name = "zakaria-key"
  security_groups = [ aws_security_group.public_ec2_sg.id ]
  user_data = data.template_file.wordpress_user_data.rendered

  depends_on = [ var.ngw, var.private_nlb ]

  lifecycle {
    create_before_destroy = true
  }

}




resource "aws_autoscaling_group" "autoscalling_group" {
  name                 = "${terraform.workspace}-wp-asg-zakaria"
  launch_configuration = aws_launch_configuration.wp_ec2_lc.name
  min_size             = 1
  max_size             = 3
  health_check_grace_period = 60
  # health_check_type         = "ELB"
  desired_capacity          = 2
  vpc_zone_identifier   = var.private_subnet_ids


  tag {
    key                 = "${terraform.workspace}-asg-key"
    value               = "${terraform.workspace}-asg-value"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_attachment" "asg_attachment_tg" {
  autoscaling_group_name = aws_autoscaling_group.autoscalling_group.id
  alb_target_group_arn   = var.external_alb_target_group_arn
}
