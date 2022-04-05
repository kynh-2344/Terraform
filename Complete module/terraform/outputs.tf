# NETWORK LAYER
# output "vpc_id" {
#     value = module.network_layer.vpc_id
# }

# output "igw_id" {
#     value = module.network_layer.igw_id
# }

# output "private_subnets" {
#     value = module.network_layer.private_subnets
# }

# output "public_subnets" {
#     value = module.network_layer.public_subnets
# }

# output "nat_gateway_public_ip" {
#     value = module.network_layer.nat_gateway_public_ip
# }

# output "public_route_table_name" {
#     value = module.network_layer.public_route_table_name
# }

# output "private_route_table_name" {
#     value = module.network_layer.private_route_table_name
# }

# RDS LAYER
output "aurora_user" {
    value = var.aurora_user
}
output "aurora_password" {
    value = module.database_layer.aurora_password
}

output "aurora_rds_database" {
    value = module.database_layer.aurora_rds_cluster_database
}

# output "aurora_rds_instance_endpoint" {
#     value = module.database_layer.aurora_rds_instance_endpoint
# }

output "aurora_rds_cluster_endpoint" {
    value = module.database_layer.aurora_rds_cluster_endpoint
}

# ELASTICACHE LAYER
# output "elasticache_primary_endpoint" {
#     value = module.cache_layer.elasticache_primary_endpoint
# }

# output "elasticache_reader_endpoint" {
#     value = module.cache_layer.elasticache_reader_endpoint
# }

output "elasticache_configure_endpoint" {
    value = module.cache_layer.elasticache_endpoint
}

# S3 LAYER
output "s3_domain_name" {
    value = module.storage_layer.web_static_domain_name
}

output "bucket_arns" {
    value = module.storage_layer.bucket_arns
}


# FRONTEND LAYER
output "frontent_lb_dns_name" {
    value = module.front_layer.load_balance_dns
}

# output "app_lb_dns_name" {
#     value = module.app_layer.load_balance_dns
# }

resource "local_file" "ansible_vars" {
    filename    = "../ansible/app/group_vars/app_role/main.yml"
    content     = <<EOF
aurora_user: ${var.aurora_user}
aurora_password: ${module.database_layer.aurora_password}
aurora_database: ${module.database_layer.aurora_rds_cluster_database}
aurora_endpoint: ${module.database_layer.aurora_rds_cluster_endpoint}
elasticache_endpoint: ${module.cache_layer.elasticache_primary_endpoint}
s3_domain_name: ${jsonencode(split(",",(join(",",module.storage_layer.web_static_domain_name))))}
efs_dns_name: ${module.efs_layer.efs_dns_name}
iam_access_id: 
iam_secret_access_key: 
EOF 
}

# EFS LAYER
output "efs_mount_target_dns_name" {
    value = module.efs_layer.efs_mount_target_dns_name
}
