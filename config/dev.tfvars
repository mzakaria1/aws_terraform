                        #-------------- AWS Region
aws_region = "us-west-2"

                        #-------------- VPC Variables 
vpc_cidr_block      = "10.0.0.0/16"

                        #-------------- Subnet Variables

pub_sbn_cidr_block = ["10.0.1.0/24","10.0.2.0/24"]
pvt_sbn_cidr_block = ["10.0.3.0/24","10.0.4.0/24"]
availability_zone = ["us-west-2a", "us-west-2b"]

database_ubuntu_ami = "ami-0928f4202481dfdf6"
database_instance_type = "t2.micro"
database_key_name = "zakaria-key"


launch_template_ami = "ami-0e999cbd62129e3b1"
launch_template_instance_type = "t2.micro"
health_check_path ="/"

