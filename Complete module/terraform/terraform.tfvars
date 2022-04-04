# NETWORK LAYER
region                          = "us-east-1"
project                         = "wordpress"
environment                     = "lab"
vpc_cidr_block                  = "10.0.0.0/16"
public_subnet_number            = 2
eip_number                      = 2
public_cidr_blocks              = [
    "10.0.1.0/24",
    "10.0.2.0/24"
]

private_subnet_number           = 2
private_cidr_blocks             = [
    "10.0.3.0/24",
    "10.0.4.0/24"
]

instance_number                 = 2
instance_class                  = "t3.small"
instance_type                   = "t2.micro"
database_engine                 = "mysql"
database_version                = "5.7.12"
aurora_user                     = "admin"
aurora_database_name            = "aurora"
aurora_parameter_group  = [
    {
        name    = "log_output"
        value   = "FILE"
    },
    {
        name    = "log_warnings"
        value   = "2"
    },
    {
        name    = "slow_query_log"
        value   = "1"
    },
    {
        name    = "log_queries_not_using_indexes"
        value   = "1"
    },
    {
        name    = "long_query_time"
        value   = "5"
    },
    {
        name    = "general_log"
        value   = "1"
    },
    {
        name    = "innodb_lock_wait_timeout"
        value   = "50"
    }
]
replicas_per_node_group         = 1
node_class                      = "t3.small"
cache_engine                    = "redis"
cache_version                   = "6.x"
cache_family                    = "redis6.x"
elasticache_parameter_group     = [
    {
        name    = "activedefrag"
        value   = "yes"
    },
    {
        name    = "activerehashing"
        value   = "yes"
    },
    {
        name    = "cluster-enabled"
        value   = "no"
    }
]
backup_retention_period         = 1
instance_volume_size            = 20
instance_volume_type            = "gp3"
instance_keypair_name           = "aws-key"
bastion_instance_number         = 1
min_scale_size                  = 2
max_scale_size                  = 4
app_cpu_target                  = 40.0
bucket_list                     = [
    "app-log",
    "app-static-file"
]
efs_performance_mode            = "generalPurpose"
efs_throughput_mode             = "bursting"


