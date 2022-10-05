# 4. Create a Route tables
resource "aws_route_table" "public-route-table-1" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.default_cidr_block
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "public-rt-1"
  }
}
resource "aws_route_table" "public-route-table-2" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.default_cidr_block
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "public-rt-2"
  }
}
resource "aws_route_table" "private-route-table-1" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.default_cidr_block
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "private-rt-1"
  }
}
resource "aws_route_table" "private-route-table-2" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.default_cidr_block
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "private-rt-2"
  }
}

