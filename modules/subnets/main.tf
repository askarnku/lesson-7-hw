resource "aws_subnet" "subnet" {
  count                   = length(var.subnets)
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnets[count.index].cidr_block
  map_public_ip_on_launch = var.subnets[count.index].map_public_ip
  availability_zone       = var.subnets[count.index].az

  tags = {
    Name = var.subnets[count.index].tag
  }
}

