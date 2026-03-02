# Networking module outputs

output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC."
  value       = aws_vpc.vpc.cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs (order matches availability_zones)."
  value       = [for k in sort(keys(aws_subnet.public)) : aws_subnet.public[k].id]
}

output "public_subnet_id_by_az" {
  description = "Map of availability zone index to public subnet ID."
  value       = { for k, s in aws_subnet.public : k => s.id }
}

output "web_subnet_ids" {
  description = "List of web (private) subnet IDs (order matches availability_zones)."
  value       = [for k in sort(keys(aws_subnet.web)) : aws_subnet.web[k].id]
}

output "web_subnet_id_by_az" {
  description = "Map of availability zone index to web subnet ID."
  value       = { for k, s in aws_subnet.web : k => s.id }
}

output "database_subnet_ids" {
  description = "List of database (private) subnet IDs (order matches availability_zones)."
  value       = [for k in sort(keys(aws_subnet.database)) : aws_subnet.database[k].id]
}

output "database_subnet_id_by_az" {
  description = "Map of availability zone index to database subnet ID."
  value       = { for k, s in aws_subnet.database : k => s.id }
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway."
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs (one per AZ)."
  value       = [for k, ngw in aws_nat_gateway.nat_gateway : ngw.id]
}

output "public_route_table_id" {
  description = "ID of the public route table."
  value       = aws_route_table.public.id
}

output "availability_zones" {
  description = "List of availability zones used by subnets."
  value       = var.availability_zones
}