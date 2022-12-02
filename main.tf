resource "random_password" "db_master_pass" {
  length           = 40
  special          = true
  min_special      = 5
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db-pass" {
  name = "db-pass"
}

resource "aws_secretsmanager_secret_version" "db-pass-val" {
  secret_id = aws_secretsmanager_secret.db-pass.id
  secret_string = jsonencode(
    {
      username = aws_rds_cluster.cluster.master_username
      password = aws_rds_cluster.cluster.master_password
      engine   = "mysql"
      host     = aws_rds_cluster.cluster.endpoint
    }
  )
}


resource "aws_security_group" "rds-security-group" {
  name        = "rds_sg-${var.name}"
  description = "Access rds Eye DB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.vpc_cidr
  }

}


resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = random_password.db_master_pass.result
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rds-security-group.id]
  db_subnet_group_name = aws_db_subnet_group.default.name
  parameter_group_name = aws_db_parameter_group.default[0].id
}


resource "aws_db_parameter_group" "default" {
  name   = "rds-pg"
  family = "mysql5.7"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}


resource "aws_db_subnet_group" "default" {
  subnet_ids = var.subnet_ids
}
