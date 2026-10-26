resource "aws_vpc" "this" { cidr_block = var.vpc_cidr; enable_dns_hostnames = true; tags = { Name = "${var.name}-vpc" } }
resource "aws_internet_gateway" "this" { vpc_id = aws_vpc.this.id; tags = { Name = "${var.name}-igw" } }
resource "aws_subnet" "public" { count = length(var.azs); vpc_id = aws_vpc.this.id; availability_zone = var.azs[count.index]; cidr_block = var.public_cidrs[count.index]; map_public_ip_on_launch = false; tags = { Name = "${var.name}-public-${count.index + 1}" } }
resource "aws_subnet" "private" { count = length(var.azs); vpc_id = aws_vpc.this.id; availability_zone = var.azs[count.index]; cidr_block = var.private_cidrs[count.index]; tags = { Name = "${var.name}-private-${count.index + 1}" } }
resource "aws_subnet" "database" { count = length(var.azs); vpc_id = aws_vpc.this.id; availability_zone = var.azs[count.index]; cidr_block = var.db_cidrs[count.index]; tags = { Name = "${var.name}-db-${count.index + 1}" } }
resource "aws_route_table" "public" { vpc_id = aws_vpc.this.id; tags = { Name = "${var.name}-public-rt" } }
resource "aws_route" "internet" { route_table_id = aws_route_table.public.id; destination_cidr_block = "0.0.0.0/0"; gateway_id = aws_internet_gateway.this.id }
resource "aws_route_table_association" "public" { count = length(var.azs); subnet_id = aws_subnet.public[count.index].id; route_table_id = aws_route_table.public.id }
# Private routes deliberately have no internet egress by default. Add VPC endpoints or per-AZ NAT if required.
resource "aws_route_table" "private" { count = length(var.azs); vpc_id = aws_vpc.this.id; tags = { Name = "${var.name}-private-rt-${count.index + 1}" } }
resource "aws_route_table_association" "private" { count = length(var.azs); subnet_id = aws_subnet.private[count.index].id; route_table_id = aws_route_table.private[count.index].id }
resource "aws_route_table" "database" { count = length(var.azs); vpc_id = aws_vpc.this.id; tags = { Name = "${var.name}-db-rt-${count.index + 1}" } }
resource "aws_route_table_association" "database" { count = length(var.azs); subnet_id = aws_subnet.database[count.index].id; route_table_id = aws_route_table.database[count.index].id }
