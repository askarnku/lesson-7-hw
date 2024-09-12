output "subnet_ids" {
  value = aws_subnet.subnet[*].id
}

output "subnets" {
  value = [
    for subnet in aws_subnet.subnet : {
      id                      = subnet.id
      map_public_ip_on_launch = subnet.map_public_ip_on_launch
    }
  ]
}
