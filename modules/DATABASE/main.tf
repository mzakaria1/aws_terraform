

resource "aws_security_group" "database_sg" {
  name        = "${terraform.workspace}-database-ec2-sg-zakaria"
  description = "Allow traffic of Network Load balancer using 3306 port"
  vpc_id      = var.vpc_id

#   ingress {
#     description = "Network Load Balancer inbound traffic"
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = [var.internal_nlb_sg_id]    //Need to change with private network load balancer security group 
#   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${terraform.workspace}-database-ec2-sg-zakaria"
  }
}

resource "aws_security_group_rule" "database_sg_with_internal_nlb" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.database_sg.id
  source_security_group_id = var.internal_nlb_sg_id
}



data "template_file" "database_user_data_file" {
  template = file("${path.module}/mysql.tpl")
}

# data "template_cloudinit_config" "database_user_data_base64" {
#   gzip          = true
#   base64_encode = true

#   #second part
#   part {
#     content_type = "text/x-shellscript"
#     content      = data.template_file.database_user_data_file.rendered
#   }
# }


resource "aws_instance" "database_ec2" {
  ami           = var.database_ubuntu_ami
  instance_type = var.database_instance_type
  key_name = var.database_key_name
  security_groups = [ aws_security_group.database_sg.id ]
  user_data = data.template_file.database_user_data_file.rendered
  subnet_id = var.private_subnet_ids[0]
  depends_on = [ var.ngw ]

  tags = {
    Name = "${terraform.workspace}-database-ec2-zakaria"
  }
}
