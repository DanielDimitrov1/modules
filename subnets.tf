# 3. Create 2 PUBLIC subnets:
resource "aws_subnet" "publicsubnet1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.cidr_block_public_subnet1
  availability_zone = var.AZone1
  map_public_ip_on_launch = true

  tags = {
    Name = "publicsubnet1"
  }
}
resource "aws_subnet" "publicsubnet2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.cidr_block_public_subnet2
  availability_zone = var.AZone2
  map_public_ip_on_launch = true

  tags = {
    Name = "publicsubnet2"
  }
}
# 3.1 Create 2 PRIVATE subnets:
resource "aws_subnet" "privatesubnet1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.cidr_block_private_subnet1
  availability_zone = var.AZone1
  map_public_ip_on_launch = false

  tags = {
    Name = "privatesubnet1"
  }
}
resource "aws_subnet" "privatesubnet2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.cidr_block_public_subnet2
  availability_zone = var.AZone2
  map_public_ip_on_launch = false

  tags = {
    Name = "privatesubnet2"
  }
}


