variable "name" { type = string }
variable "subnet_ids" { type = list(string) }
variable "security_group_id" { type = string }
variable "instance_class" { type = string }
variable "multi_az" { type = bool }
variable "backup_retention_period" { type = number }
