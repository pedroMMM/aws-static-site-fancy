data "aws_route53_zone" "domain" {
  zone_id      = var.hosted_zone_id
  private_zone = false
}

locals {
  hostname = var.subdomain == null ? data.aws_route53_zone.domain.name : format("%s.%s", var.env, data.aws_route53_zone.domain.name)
}

resource "aws_route53_record" "cdn" {
  zone_id = var.hosted_zone_id
  name    = local.hostname
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = true

  }
}
