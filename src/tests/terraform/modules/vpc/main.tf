data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_vpc" "demo_cluster" {
  cidr_block = var.vpc_cidr_block

  enable_dns_hostnames = true

  tags = var.vpc_tags
}

resource "aws_subnet" "demo_cluster" {
  count = var.vpc_subnet_count

  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.demo_cluster.cidr_block, 4, count.index)
  vpc_id                  = aws_vpc.demo_cluster.id
  map_public_ip_on_launch = true

  tags = var.vpc_tags
}

resource "aws_internet_gateway" "demo_node_group" {
  vpc_id = aws_vpc.demo_cluster.id
}

resource "aws_route" "demo_node_group_external" {
  route_table_id         = aws_vpc.demo_cluster.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.demo_node_group.id
}