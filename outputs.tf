output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "dmz_subnet_ids" {
  description = "List of IDs of DMZ subnets"
  value       = aws_subnet.dmz[*].id
}

output "logic_subnet_ids" {
  description = "List of IDs of Logic subnets"
  value       = aws_subnet.logic[*].id
}

output "data_subnet_ids" {
  description = "List of IDs of Data subnets"
  value       = aws_subnet.data[*].id
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.this[*].id
}
output "vpc_flow_logs_log_group" {
  description = "The CloudWatch Log Group for VPC Flow Logs"
  value       = aws_cloudwatch_log_group.vpc_flow_logs.name
}