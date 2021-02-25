output "vpc_id" {
  value = aws_vpc.zakaria_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public_subnets.*.id
}

output "private_subnets" {
  value = aws_subnet.private_subnets.*.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "private_route_table_association" {
  value = aws_route_table_association.private_route_table_association
}

output "ngw" {
  value = aws_nat_gateway.ngw
}