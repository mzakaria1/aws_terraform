
                                    # VPC 
resource "aws_vpc" "zakaria_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
      Name = "${terraform.workspace}-vpc-zakaria"
  }
}


                                    # Public Subnets
resource "aws_subnet" "public_subnets" {
  count = length(var.pub_sbn_cidr_block)
  vpc_id = aws_vpc.zakaria_vpc.id
  cidr_block = element(var.pub_sbn_cidr_block, count.index)
  tags = {
    Name = "${terraform.workspace}-pub-sbn-${count.index + 1}-zakaria"
  }
  availability_zone = element(var.availability_zone, count.index)
  # map_public_ip_on_launch = true
}

                                    # Private Subnets
resource "aws_subnet" "private_subnets" {
  count = length(var.pvt_sbn_cidr_block)
  vpc_id = aws_vpc.zakaria_vpc.id
  cidr_block = element(var.pvt_sbn_cidr_block, count.index)
  tags = {
    Name = "${terraform.workspace}-pvt-sbn-${count.index + 1}-zakaria"
  }
  availability_zone = element(var.availability_zone, count.index)
}


                                    # Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.zakaria_vpc.id

  tags = {
    Name = "${terraform.workspace}-IG-zakaria"
  }
}

                                    # Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.zakaria_vpc.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${terraform.workspace}-pub-rt-zakaria"
  }
}

                                    # Public Route Table associations with Subnets
resource "aws_route_table_association" "public_route_table_association" {
  count = length(aws_subnet.public_subnets)
  subnet_id = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}


                                    # Elastic IP
resource "aws_eip" "eip" {
  vpc = true
}

                                    # NAT Gateway
resource "aws_nat_gateway" "ngw" {
  subnet_id   = aws_subnet.public_subnets[0].id
  allocation_id = aws_eip.eip.id

  tags = {
    Name = "${terraform.workspace}-ngw-zakaria"
  }
}

                                    # Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.zakaria_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "${terraform.workspace}-pvt-rt-zakaria"
  }
}

                                    # Private Route Table associations with Subnets
resource "aws_route_table_association" "private_route_table_association" {
  count = length(aws_subnet.private_subnets)
  subnet_id = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}






