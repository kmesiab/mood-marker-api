output "app_url" {
  value = aws_lb.mood_maker_api_lb.dns_name
}