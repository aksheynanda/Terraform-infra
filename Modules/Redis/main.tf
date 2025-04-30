resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = [var.redis_subnet1, var.redis_subnet2]
}

data "aws_secretsmanager_secret_version" "redis_token" {
  secret_id = "arn:aws:secretsmanager:us-east-1:851765306105:secret:redis-auth-token-GR8Qsz"
}


resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = "my-redis-cluster"
#  replication_group_description = "Redis cluster for app caching"
  description = "Redis cluster for app caching"
  engine                        = "redis"
  engine_version                = "7.0" # You can adjust version
  auth_token = jsondecode(data.aws_secretsmanager_secret_version.redis_token.secret_string)["auth_token"]
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  node_type                     = "cache.t3.micro"
#  number_cache_clusters         = 2
  port                          = 6379
  automatic_failover_enabled    = true
  parameter_group_name          = "default.redis7"
  subnet_group_name             = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids            = [var.redis_sg]

  tags = {
    Environment = "dev"
  }
}
