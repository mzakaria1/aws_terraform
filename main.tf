
module "vpc" {
    source = "./modules/VPC"
    aws_region = var.aws_region
    vpc_cidr_block = var.vpc_cidr_block
    pub_sbn_cidr_block = var.pub_sbn_cidr_block
    pvt_sbn_cidr_block = var.pvt_sbn_cidr_block
    availability_zone = var.availability_zone
}


module "database_instance" {
    source = "./modules/DATABASE"
    vpc_id = module.vpc.vpc_id
    database_ubuntu_ami = var.database_ubuntu_ami
    database_instance_type = var.database_instance_type
    database_key_name = var.database_key_name
    private_subnet_ids = module.vpc.private_subnets
    internal_nlb_sg_id = module.private_nlb.internal_nlb_sg_id
    ngw = module.vpc.ngw
}


module "private_nlb" {
    source = "./modules/NLB"
    vpc_id = module.vpc.vpc_id
    database_ec2_instance_id = module.database_instance.database_ec2_instance_id
    private_subnet_ids = module.vpc.private_subnets
    public_wordpress_ec2_sg_id = module.autoscalling_group.public_wordpress_ec2_sg_id
}



module "external_alb" {
    source = "./modules/ALB"
    vpc_id = module.vpc.vpc_id
    public_subnets = module.vpc.public_subnets
    health_check_path = var.health_check_path
}


module "autoscalling_group" {
    source = "./modules/ASG"
    vpc_id = module.vpc.vpc_id
    launch_template_ami = var.launch_template_ami
    launch_template_instance_type = var.launch_template_instance_type
    external_alb_target_group_arn = module.external_alb.external_alb_target_group_arn
    private_subnet_ids = module.vpc.private_subnets
    internal_nlb_dns_name = module.private_nlb.internal_nlb_dns_name
    external_alb_sg_id = module.external_alb.external_alb_sg_id
    ngw = module.vpc.ngw
    private_nlb = module.private_nlb.private_nlb
}
