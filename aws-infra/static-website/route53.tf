data "aws_route53_zone" "public" {
  name         = var.domain
  private_zone = false
}


# This creates an SSL certificate
resource "aws_acm_certificate" "dd_solutions" {

  domain_name       = var.domain
  subject_alternative_names = ["vivekmishra.doubledigit-solutions.com", "www.vivekmishra.doubledigit-solutions.com"]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# This is a DNS record for the ACM certificate validation to prove we own the domain
resource "aws_route53_record" "cert_validation" {

  for_each = {
  for dvo in aws_acm_certificate.dd_solutions.domain_validation_options : dvo.domain_name => {
    name   = dvo.resource_record_name
    record = dvo.resource_record_value
    type   = dvo.resource_record_type
  }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id  = data.aws_route53_zone.public.id
  ttl      = 300
}

# This tells terraform to cause the route53 validation to happen
resource "aws_acm_certificate_validation" "cert" {

  timeouts {
    create = "20m"
  }

  certificate_arn         = aws_acm_certificate.dd_solutions.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}


resource "aws_route53_record" "portfolio_web_1" {
  zone_id  = data.aws_route53_zone.public.zone_id
  name     = "vivekmishra.doubledigit-solutions.com"
  type     = "A"

  alias {
    name    = aws_cloudfront_distribution.s3_dd_distribution.domain_name
    zone_id = aws_cloudfront_distribution.s3_dd_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "portfolio_web_2" {
  zone_id  = data.aws_route53_zone.public.zone_id
  name     = "www.vivekmishra.doubledigit-solutions.com"
  type     = "A"

  alias {
    name    = aws_cloudfront_distribution.s3_dd_distribution.domain_name
    zone_id = aws_cloudfront_distribution.s3_dd_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}