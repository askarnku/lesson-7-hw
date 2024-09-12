resource "aws_route_table" "rtb" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"

    # are we doing route table for igw (for all internet) or nat for private subs
    # for igw
    gateway_id = var.igw_id ? null : var.igw_id

    # for nat
    nat_gateway_id = var.nat_gateway_id ? null : var.nat_gateway_id
  }

  tags = {
    Name = "${var.igw_id ? "public" : "private"}_rtb"
  }
}

resource "aws_route_table_association" "assoc" {
  count          = length(var.subnets)
  subnet_id      = var.subnets[count.index]
  route_table_id = aws_route_table.rtb.id
}
