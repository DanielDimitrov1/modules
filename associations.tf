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
