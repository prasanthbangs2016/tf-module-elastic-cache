resource "aws_ssm_parameter" "elasticache" {
  name  = "mutable.elasticache.${var.env}.REDIS_HOST"
  type  = "String"
  value = aws_elasticache_cluster.redis.cache_nodes[0].address

}