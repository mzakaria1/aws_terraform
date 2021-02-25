                        #----------- AWS Region
variable "aws_region" {}

                        #----------- VPC Variables
variable "vpc_cidr_block" {}

                        #----------- Subnet Variables
                            # Public Subnet 
variable "pub_sbn_cidr_block"  {}

                            # Private Subnet 
variable "pvt_sbn_cidr_block"  {}

                            # Availability Zone 
variable "availability_zone"  {}





variable "health_check_path" {}

variable "launch_template_ami" {}
variable "launch_template_instance_type" {}



variable "database_ubuntu_ami" {}
variable "database_instance_type"{}
variable "database_key_name" {}

