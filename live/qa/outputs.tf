output "vpc_id" { value = module.network.vpc_id }
output "alb_dns" { value = try(module.alb[0].dns_name, null) }
output "db_endpoint" { value = try(module.database[0].endpoint, null) }
