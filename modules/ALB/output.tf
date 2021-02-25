output "external_alb_target_group_arn" {
    value = aws_lb_target_group.external_alb_target_group.arn
}

output "external_alb_sg_id" {
    value = aws_security_group.alb_sg.id
}