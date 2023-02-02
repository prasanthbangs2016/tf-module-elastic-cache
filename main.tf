resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "Rshop-${var.env}-redis"
  engine               = "redis"
  node_type            = var.redis_instance_class
  num_cache_nodes      = var.redis_instance_count
  parameter_group_name = aws_elasticache_parameter_group.main.name
  engine_version       = var.redis_engine_version
  subnet_group_name = aws_elasticache_subnet_group.main.name
  port                 = 6379
}

resource "aws_elasticache_parameter_group" "main" {
  name   = "rshop-${var.env}-pg"
  family = "redis6.x"

#  parameter {
#    name  = "activerehashing"
#    value = "yes"
#  }
#
#  parameter {
#    name  = "min-slaves-to-write"
#    value = "2"
#  }
}

resource "aws_elasticache_subnet_group" "main" {
  name       = "Rshop-${var.env}-subnet-grp"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "Rshop-${var.env}-subnet-grp"
  }
}

resource "aws_security_group" "main" {
  name        = "roboshop-${var.env}-docdb"
  description = "roboshop-${var.env}-docdb"
  vpc_id      = var.vpc_id

  ingress {
    description      = "redis"
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]

  }


  tags = {
    Name = "Roboshop-${var.env}-redis"
  }
}