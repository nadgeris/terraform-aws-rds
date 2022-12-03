output "rds_endpoint" {
  value       = "${trim("${aws_db_instance.default.endpoint}", ":3306")}"
  description = "rds_endpoint"
}

output "rds_password" {
  value       = "${jsondecode(nonsensitive(aws_secretsmanager_secret_version.snyprdb.secret_string))["password"]}"
  description = "rds-password"
}