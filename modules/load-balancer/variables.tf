variable "name" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "vpc_id" { type = string }
variable "security_group_id" { type = string }
variable "app_port" { type = number }
variable "certificate_arn" { type = string }
