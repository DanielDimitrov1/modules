provider "aws" {
  region     = "eu-central-1"
}




# 1. Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "daniel"
  }
}




# 2. Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "maingw"
  }
}





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





# 5. Associate subnets with route tables
# Associate PUBLIC subnet 1 with a public-route-table-1
resource "aws_route_table_association" "public-subnet1-route" {
  subnet_id      = aws_subnet.publicsubnet1.id
  route_table_id = aws_route_table.public-route-table-1.id
}
# Associate PUBLIC subnet 2 with a public-route-table-2
resource "aws_route_table_association" "public-subnet2-route" {
  subnet_id      = aws_subnet.publicsubnet2.id
  route_table_id = aws_route_table.public-route-table-2.id
}
# Associate PRIVATE subnet 1 with a private-route-table-1
resource "aws_route_table_association" "private-subnet1-route" {
  subnet_id      = aws_subnet.privatesubnet1.id
  route_table_id = aws_route_table.private-route-table-1.id
}
# Associate PRIVATE subnet 2 with a private-route-table-2
resource "aws_route_table_association" "private-subnet2-route" {
  subnet_id      = aws_subnet.privatesubnet2.id
  route_table_id = aws_route_table.public-route-table-2.id
}





# 6. Create a security group
resource "aws_security_group" "allowweb" {
  name        = "allowweb"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.default_cidr_block
  }
  ingress {
    description      = "SSH"
    from_port        = 22 
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.default_cidr_block
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" #means any protocol
    cidr_blocks      = var.default_cidr_block
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allowweb"
  }
}






# 7. Create Elastic IP for NAT
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on =[aws_internet_gateway.gw]
  
  tags = {
    Name = "NAT Gateway for Elastic IP"
  }
}





# 8. Create NAT gateway 
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.publicsubnet1.id

  tags = {
    Name = "NAT Gateway for VPC"
  }
}




# 9. Create EC2 instances in private subnets  
resource "aws_instance" "instance1" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  subnet_id	  = "${aws_subnet.privatesubnet1.id}"
  security_groups = [aws_security_group.allowweb.id]
 

  tags = {
    Name = "instance1-in-private-subnet-1"
  }
  depends_on = [
    aws_nat_gateway.nat
  ]
}
resource "aws_instance" "instance2" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  subnet_id       = "${aws_subnet.privatesubnet2.id}"
  security_groups = [aws_security_group.allowweb.id]
  
  tags = {
    Name = "instance2-in-private-subnet-2"
  }
  depends_on = [
    aws_nat_gateway.nat
  ]
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"] # Canonical
}


# 10. BASTION - EC2 and security group
resource "aws_instance" "bastion" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t2.micro"
  key_name        = var.key_name
  subnet_id       = "${aws_subnet.publicsubnet1.id}"
  security_groups = [aws_security_group.bastion.id]

  tags = {
    Name = "bastion"
  }
}
resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allow traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "bastion"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks	     = var.default_cidr_block
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.default_cidr_block
  }

  tags = {
    Name = "Bastion"
  }
}






# 11. Create a load balancer
resource "aws_lb" "loadbalancer" {
  name               = "loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allowweb.id]
  subnets            = [aws_subnet.privatesubnet1.id, aws_subnet.privatesubnet2.id]

  tags = {
    Name = "loadbalancer"
  }
}

# 1. Create VPC
# 2. Create Internet Gateway
# 3. Create 2 PUBLIC subnets:
# 3.1 Create 2 PRIVATE subnets:
# 4. Create a Route tables
# 5. Associate subnets with route tables
# 6. Create a security group
# 7. Create Elastic IP for NAT
# 8. Create NAT gateway for VPC
# 9. Create EC2 instances in private subnets  
# 10. BASTION - EC2 and security group
# 11. Create a load balancer
