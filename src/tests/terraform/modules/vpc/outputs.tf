output "vpc_subnet_ids" {
  value = aws_subnet.demo_cluster[*].id
}
