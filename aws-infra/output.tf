output "s3_bucket_website_endpoint" {
  value       = aws_s3_bucket.website_bucket.website_endpoint
  description = "The website endpoint URL"
}

output "website_domain" {
  value = aws_route53_record.portfolio_web_1.fqdn
  description = "Portfolio endpoint"
}

output "website_domain_2" {
  value = aws_route53_record.portfolio_web_1.fqdn
  description = "Portfolio endpoint"
}