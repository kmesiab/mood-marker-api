output "load_balancer_url" {
  value = aws_lb.mood_maker_api_lb.dns_name
}

output "api_url" {
  value = "https://langtool.net"
}