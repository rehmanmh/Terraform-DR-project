resource "aws_security_group" "alb" { name_prefix = "${var.name}-alb-"; vpc_id = var.vpc_id; tags = { Name = "${var.name}-alb" } }
resource "aws_vpc_security_group_ingress_rule" "https" { for_each = toset(var.allowed_ingress_cidrs); security_group_id = aws_security_group.alb.id; cidr_ipv4 = each.value; from_port = 443; to_port = 443; ip_protocol = "tcp" }
resource "aws_vpc_security_group_egress_rule" "alb_to_app" { security_group_id = aws_security_group.alb.id; referenced_security_group_id = aws_security_group.app.id; from_port = var.app_port; to_port = var.app_port; ip_protocol = "tcp" }
resource "aws_security_group" "app" { name_prefix = "${var.name}-app-"; vpc_id = var.vpc_id; tags = { Name = "${var.name}-app" } }
resource "aws_vpc_security_group_ingress_rule" "from_alb" { security_group_id = aws_security_group.app.id; referenced_security_group_id = aws_security_group.alb.id; from_port = var.app_port; to_port = var.app_port; ip_protocol = "tcp" }
resource "aws_vpc_security_group_egress_rule" "app_to_db" { security_group_id = aws_security_group.app.id; referenced_security_group_id = aws_security_group.db.id; from_port = var.db_port; to_port = var.db_port; ip_protocol = "tcp" }
resource "aws_security_group" "db" { name_prefix = "${var.name}-db-"; vpc_id = var.vpc_id; tags = { Name = "${var.name}-db" } }
resource "aws_vpc_security_group_ingress_rule" "from_app" { security_group_id = aws_security_group.db.id; referenced_security_group_id = aws_security_group.app.id; from_port = var.db_port; to_port = var.db_port; ip_protocol = "tcp" }
