resource "aws_instance" "ec2" {
  count = length(var.subnet_ids)

  ami           = var.ami != null ? var.ami : data.aws_ami.latest_ami.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_ids[count.index]
  tags = {
    Name = var.ec2_tag
  }
  security_groups = var.security_groups
  key_name        = var.key_name
  user_data       = var.user_data != "" ? var.user_data : file("${path.module}/user_data.sh")
}
