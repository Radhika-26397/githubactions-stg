output "InstanceID" {
  description = "List of IDs of instances"
  value       = ["${aws_instance.web-1.id}"]
}
output "Instance_PrivateIP" {
  description = "List of IDs of instances"
  value       = ["${aws_instance.web-1.private_ip}"]
}

output "VPC_ID" {
  description = "This is the ID of VPC"
  value       = ["${aws_vpc.default.id}"]
}
output "Public_Subnet_IDs" {
  description = "Subnets IDs of public subnet"
  value       = ["${aws_subnet.subnet1-public.id},${aws_subnet.subnet2-public.id}"]
}

output "Private_Subnet_ID1" {
  description = "Subnets IDs of private subnet"
  value       = aws_subnet.subnet1-private.id
}
output "Internet_Gateway_Name" {
  description = "Internet gateway"
  value       = aws_internet_gateway.IG2.tags.Name
}
output "Routetable_Name" {
  description = "Routetable"
  value       = aws_route_table.RT2.tags.Name
}
output "Routetable_ID" {
  description = "Routetable"
  value       = aws_route_table.RT2.id
}
output "vpc_security_group_ids" {
  description = "List of associated security groups of instances, if running in non-default VPC"
  value       = ["${aws_instance.web-1.*.vpc_security_group_ids}"]
}






