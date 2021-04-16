output "vpc_id" {
  value = aws_vpc.community_day_vpc.id
}

output "public_subnet_1a" {
  value = aws_subnet.community_day_public_1a.id
}

output "route_table_main" {
  value = aws_default_route_table.community_day_public_table.id
}