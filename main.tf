locals {
  db_creds = merge(
    tomap({
      "password" = random_password.password.result
    })
  )
}

resource "random_password" "password" {
  length  = 16
  special = true
  override_special = "_!%^"
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_secretsmanager_secret" "snyprdb" {
  name = format("prod/mysql/snyprappdb")
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "snyprdb" {
  secret_id     = aws_secretsmanager_secret.snyprdb.id
  secret_string = jsonencode(local.db_creds)
  depends_on    = [aws_secretsmanager_secret.snyprdb]
}


resource "aws_security_group" "rds-security-group" {
  name        = "rds_sg-${var.name}"
  description = "Access rds Eye DB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

}


resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = jsondecode(nonsensitive(aws_secretsmanager_secret_version.snyprdb.secret_string))["password"]
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rds-security-group.id]
  db_subnet_group_name = aws_db_subnet_group.default.name
  parameter_group_name = aws_db_parameter_group.default.id
  publicly_accessible = true
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


# resource "null_resource" "create-db" {
#   provisioner "local-exec" {
#     command     = "for item in $ITEMS; do echo $item >> test-file; done"
#     environment = { 
#       ITEMS = join(" ", var.items) 
#       }
#   }
# }

# resource "null_resource" "create-table" {
#   provisioner "local-exec" {
#     command     = "for item in $ITEMS; do echo $item >> test-file; done"
#     environment = { 
#       ITEMS = join(" ", var.items) 
#       }
#   }
# }

resource "null_resource" "add-data" {
  provisioner "local-exec" {
    command     = "python3 ../files/add-data.py --user={user}  --password={password} --host={host}"
    environment = { 
      user = "admin"
      password = jsondecode(nonsensitive(aws_secretsmanager_secret_version.snyprdb.secret_string))["password"]
      host = aws_db_instance.default.endpoint
       }
  }
}