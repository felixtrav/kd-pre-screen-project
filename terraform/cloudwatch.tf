resource "aws_cloudwatch_log_group" "adder_service" {
  name              = "/ec2/adder-service"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "display_service" {
  name              = "/ecs/display-service"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "reset_service" {
  name              = "/ecs/reset-service"
  retention_in_days = 14
}
