resource "aws_acm_certificate" "langtool_cert" {
  domain_name       = "langtool.net"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "langtool_cert_validation" {
  name    = tolist(aws_acm_certificate.langtool_cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.langtool_cert.domain_validation_options)[0].resource_record_type
  zone_id = var.route_53_hosted_zone_id
  records = [tolist(aws_acm_certificate.langtool_cert.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "langtool_cert_validation" {
  certificate_arn         = aws_acm_certificate.langtool_cert.arn
  validation_record_fqdns = [aws_route53_record.langtool_cert_validation.fqdn]
}

resource "aws_lb_listener" "langtool_https_listener" {
  load_balancer_arn = aws_lb.mood_maker_api_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.langtool_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mood_maker_api_target_group.arn
  }
}

resource "aws_route53_record" "langtool_lb" {
  zone_id = var.route_53_hosted_zone_id
  name    = "langtool.net"
  type    = "A"
  alias {
    name                   = aws_lb.mood_maker_api_lb.dns_name
    zone_id                = aws_lb.mood_maker_api_lb.zone_id
    evaluate_target_health = true
  }
}
