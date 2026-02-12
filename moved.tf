moved {
  from = aws_vpc.main
  to   = module.network.aws_vpc.main
}

moved {
  from = aws_subnet.public
  to   = module.network.aws_subnet.public
}

moved {
  from = aws_internet_gateway.main
  to   = module.network.aws_internet_gateway.main
}

moved {
  from = aws_route_table.public
  to   = module.network.aws_route_table.public
}

moved {
  from = aws_route_table_association.public
  to   = module.network.aws_route_table_association.public
}

moved {
  from = aws_subnet.private
  to   = module.network.aws_subnet.private
}

moved {
  from = aws_eip.nat_eip
  to   = module.network.aws_eip.nat_eip
}

moved {
  from = aws_nat_gateway.nat
  to   = module.network.aws_nat_gateway.nat
}

moved {
  from = aws_route_table.private
  to   = module.network.aws_route_table.private
}

moved {
  from = aws_route_table_association.private
  to   = module.network.aws_route_table_association.private
}

moved {
  from = random_string.mock_rds_suffix
  to   = module.app.random_string.mock_rds_suffix
}

moved {
  from = random_password.mock_rds_password
  to   = module.app.random_password.mock_rds_password
}

moved {
  from = random_string.page_random
  to   = module.app.random_string.page_random
}

moved {
  from = aws_security_group.alb
  to   = module.app.aws_security_group.alb
}

moved {
  from = aws_security_group.app
  to   = module.app.aws_security_group.app
}

moved {
  from = aws_iam_role.ec2
  to   = module.app.aws_iam_role.ec2
}

moved {
  from = aws_iam_role_policy_attachment.ec2_ssm
  to   = module.app.aws_iam_role_policy_attachment.ec2_ssm
}

moved {
  from = aws_iam_instance_profile.ec2
  to   = module.app.aws_iam_instance_profile.ec2
}

moved {
  from = aws_lb.app
  to   = module.app.aws_lb.app
}

moved {
  from = aws_lb_target_group.app
  to   = module.app.aws_lb_target_group.app
}

moved {
  from = aws_lb_listener.http_80
  to   = module.app.aws_lb_listener.http_80
}

moved {
  from = aws_launch_template.app
  to   = module.app.aws_launch_template.app
}

moved {
  from = aws_autoscaling_group.app
  to   = module.app.aws_autoscaling_group.app
}

