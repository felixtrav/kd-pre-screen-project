resource "aws_lb_target_group" "adder_service" {
  name     = "adder-service-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.kd_vpc.id
}

resource "aws_lb_target_group_attachment" "adder_service" {
  target_group_arn = aws_lb_target_group.adder_service.arn
  target_id        = aws_instance.adder_service.id
  port             = 80
}

# resource "aws_lb_target_group" "display_service" {
#   name     = "display-service-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.kd_vpc.id
# }
#
# resource "aws_lb_target_group" "reset_service" {
#   name     = "reset-service-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.kd_vpc.id
# }


# resource "aws_lb_target_group_attachment" "display_service" {
#   target_group_arn = aws_lb_target_group.adder_service.arn
#   target_id        = aws_instance.adder_service.id
#   port             = 80
# }
#
# resource "aws_lb_target_group_attachment" "reset_service" {
#   target_group_arn = aws_lb_target_group.adder_service.arn
#   target_id        = aws_instance.adder_service.id
#   port             = 80
# }


resource "aws_lb" "kd_alb" {
  name               = "kd-alb"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.kd_public_subnets[*].id

  depends_on = [aws_instance.adder_service]
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.kd_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.adder_service.arn
  }
}

resource "aws_lb_listener_rule" "adder_service_listener_rule" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.adder_service.arn
  }

  condition {
    path_pattern {
      values = ["/add*"]
    }
  }
}