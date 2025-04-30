data "aws_secretsmanager_secret_version" "rds_secret_value" {
  secret_id = "arn:aws:secretsmanager:us-east-1:851765306105:secret:rds_secret-hTKWdZ"
}

locals {
  rds_creds = jsondecode(data.aws_secretsmanager_secret_version.rds_secret_value.secret_string)
}

resource "aws_db_subnet_group" "default" {
  name       = "private"
  subnet_ids = [var.rds_subnet1, var.rds_subnet2]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier             = "my-postgres-db"
  engine                 = "postgres"
  instance_class         = "db.t4g.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  db_name                = "myappdb"
  username               = local.rds_creds["username"]
  password               = local.rds_creds["password"]
  publicly_accessible    = false
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [var.rds_sg]
  multi_az               = false
  backup_retention_period = 7
}
