output "Link" {
  value = "http://${aws_lb.kd_alb.dns_name}/"
}