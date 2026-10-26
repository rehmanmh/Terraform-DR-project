variable "environment" { type = string }
variable "aws_region" { type = string }
variable "name" { type = string }
variable "vpc_cidr" { type = string }
variable "azs" { type = list(string) }
variable "public_cidrs" { type = list(string) }
variable "private_cidrs" { type = list(string) }
variable "db_cidrs" { type = list(string) }
variable "allowed_ingress_cidrs" { type = list(string) }
variable "app_port" { type = number; default = 8080 }
variable "db_port" { type = number; default = 5432 }
variable "deploy_application" { type = bool; default = true }
variable "ami_id" { type = string; default = "" }
variable "certificate_arn" { type = string; default = "" }
variable "instance_type" { type = string; default = "t3.medium" }
variable "min_size" { type = number; default = 2 }
variable "max_size" { type = number; default = 6 }
variable "desired_capacity" { type = number; default = 2 }
variable "db_instance_class" { type = string; default = "db.t3.micro" }
variable "db_multi_az" { type = bool; default = false }
variable "backup_retention_days" { type = number; default = 7 }
