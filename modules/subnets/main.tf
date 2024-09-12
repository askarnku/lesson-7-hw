resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = var.az

  tags = {
    Name = var.subnet_tag
  }
}
