#############################################################
# Cloud-Front distribution for S3 static website            #
#############################################################
resource "aws_cloudfront_distribution" "s3_dd_distribution" {

  http_version = "http2"

  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id   = var.s3_origin_id

    custom_origin_config {
      // These are all the defaults.
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    custom_header {
      name  = "User-Agent"
      value = var.dd_secret
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = var.index_document

  aliases = var.aliases

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS", "POST", "PUT"]
    target_origin_id = var.s3_origin_id
    compress = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  custom_error_response {
    error_code            = "404"
    error_caching_min_ttl = "300"
    response_code         = var.error_response_code
    response_page_path    = "/${var.error_document}"
  }


  price_class = var.cloudfront_price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.dd_solutions.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
}