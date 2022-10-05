# 9. Create EC2 instances in private subnets  
resource "aws_instance" "instance1" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t2.micro"
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
  instance_type   = "t2.micro"
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
