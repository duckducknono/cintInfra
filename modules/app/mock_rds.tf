resource "random_string" "mock_rds_suffix" {
  length  = 8
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "random_password" "mock_rds_password" {
  length  = 18
  special = false
}

resource "random_string" "page_random" {
  length  = 16
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "random_string" "page_variable_random" {
  length  = 10
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "random_string" "page_secret_random" {
  length  = 10
  upper   = false
  lower   = true
  numeric = true
  special = false
}

locals {
  mock_rds = {
    engine   = "postgres"
    username = "mock_user"
    password = random_password.mock_rds_password.result
    dbname   = "mock_db"
    port     = 5432
    endpoint = "mock-${random_string.mock_rds_suffix.result}.${var.aws_region}.rds.amazonaws.com"
  }

  mock_rds_connection_string = "postgresql://${local.mock_rds.username}:${local.mock_rds.password}@${local.mock_rds.endpoint}:${local.mock_rds.port}/${local.mock_rds.dbname}"
}

