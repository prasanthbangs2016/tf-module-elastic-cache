resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "roboshop-${var.env}-redis"
  engine               = "redis"
  node_type            = var.redis_instance_class
  num_cache_nodes      = var.redis_instance_count
  parameter_group_name = aws_elasticache_parameter_group.main.name
  engine_version       = var.redis_engine_version
  subnet_group_name = aws_elasticache_subnet_group.main.name
  port                 = 6379
  security_group_ids = [aws_security_group.main.name]
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
  name       = "rshop-${var.env}-subnet-grp"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "Rshop-${var.env}-subnet-grp"
  }
}

resource "aws_security_group" "main" {
  name        = "roboshop-${var.env}-redis"
  description = "roboshop-${var.env}-redis"
  vpc_id      = var.vpc_id

  ingress {
    description      = "redis"
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]

  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }


  tags = {
    Name = "roboshop-${var.env}-redis"
  }
}


