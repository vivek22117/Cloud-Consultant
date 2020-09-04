data "aws_route53_zone" "public" {
  name         = var.domain
  private_zone = false
}


# This creates an SSL certificate
resource "aws_acm_certificate" "dd_solutions" {

  domain_name       = var.domain
  subject_alternative_names = ["*.${var.domain}"]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# This is a DNS record for the ACM certificate validation to prove we own the domain
resource "aws_route53_record" "cert_validation" {

  name     = tolist(aws_acm_certificate.dd_solutions.domain_validation_options)[0].resource_record_name
  type     = tolist(aws_acm_certificate.dd_solutions.domain_validation_options)[0].resource_record_type
  zone_id  = data.aws_route53_zone.public.id
  records  = [tolist(aws_acm_certificate.dd_solutions.domain_validation_options)[0].resource_record_value]
  ttl      = 300
}

# This tells terraform to cause the route53 validation to happen
resource "aws_acm_certificate_validation" "cert" {

  certificate_arn         = aws_acm_certificate.dd_solutions.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
