output "public_instance_ids" {
  description = "List of EC2 instance IDs with public IPs"
  value       = compact([for i, id in aws_instance.ec2[*].id : id if aws_instance.ec2[i].public_ip != null])
}

# output "public_subnets" {
#   value = [for i, subnet in aws_aws_instance.ec2[*] : subnet if aws_aws_instance.ec2[i].public_ip != null]
# }

output "ec2_ids" {
  description = "List of EC2 instance IDs with public IPs"
  value       = [for i, id in aws_instance.ec2[*].id : id if aws_instance.ec2[i].public_ip != null]
}
