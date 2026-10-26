variable "name" { type = string }
variable "vpc_id" { type = string }
variable "db_port" { type = number }
variable "app_port" { type = number }
variable "allowed_ingress_cidrs" { type = list(string) }
