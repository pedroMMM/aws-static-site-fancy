resource "aws_route53_zone" "dns" {
  name = var.hosted_zone_name
}
