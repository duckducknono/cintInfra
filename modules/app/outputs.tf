output "alb_dns_name" {
  description = "Public DNS name of the application load balancer"
  value       = aws_lb.app.dns_name
}

output "mock_rds_connection_string" {
  description = "Mock RDS connection string injected into EC2 user data"
  value       = local.mock_rds_connection_string
  sensitive   = true
}

