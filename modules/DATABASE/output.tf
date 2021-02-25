output "database_ec2_instance_id" {
    value = aws_instance.database_ec2.id
}

output "database_ec2_sg_id" {
    value = aws_security_group.database_sg.id
}

output "database_ec2" {
    value = aws_instance.database_ec2
}