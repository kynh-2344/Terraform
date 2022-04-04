resource "aws_elasticache_replication_group" "cache_replica_group" {
    automatic_failover_enabled              = true
    multi_az_enabled                        = true
    #preferred_cache_cluster_azs             = var.private_subnets
    subnet_group_name                       = aws_elasticache_subnet_group.cache_subnet.name
    replication_group_id                    = "${var.project}-elasticache-replica-group-${var.environment}"
    description                             = "Redis Cache"
    engine                                  = var.cache_engine
    engine_version                          = var.cache_version
    node_type                               = "cache.${var.node_class}"
    num_cache_clusters                      = var.cluster_number
    parameter_group_name                    = aws_elasticache_parameter_group.custom_paragroup.name
    security_group_ids                      = [var.elasticache_sg]
    port                                    = 6379
}

resource "aws_elasticache_parameter_group" "custom_paragroup" {
    name                                    = "${var.project}-parameter-group-${var.environment}"
    family                                  = var.cache_family
    dynamic "parameter" {
        for_each                            = var.elasticache_paragroup 
        content {
            name                            = parameter.value.name
            value                           = parameter.value.value
        }
    }
}

resource "aws_elasticache_subnet_group" "cache_subnet" {
    name                                    = "${var.project}-elasticache-subnet-${var.environment}"
    subnet_ids                              = var.private_subnets
}