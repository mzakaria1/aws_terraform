output "internal_nlb_sg_id" {
    value = aws_security_group.nlb_sg.id
}

output "internal_nlb_dns_name" {
    value = aws_lb.private_nlb.dns_name
}

output "private_nlb" {
    value = aws_lb.private_nlb
}