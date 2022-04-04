output "aurora_password" {
    value = random_string.aurora_password.result
}

output "aurora_rds_instance_endpoint" {
    value = aws_rds_cluster_instance.aurora_instance.*.endpoint
}

output "aurora_rds_cluster_endpoint" {
    value = aws_rds_cluster.aurora_cluster.endpoint
}

output "aurora_rds_cluster_database" {
    value = aws_rds_cluster.aurora_cluster.database_name
}
