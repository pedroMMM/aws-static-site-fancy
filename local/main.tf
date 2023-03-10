terraform {
  required_version = "1.3.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.57.1"
    }
  }

}

provider "aws" {
  default_tags {
    tags = {
      env     = "localdev"
      owner   = "pedro"
      project = "static-site-fancy"
    }
  }
}

data "aws_caller_identity" "current" {}

variable "hosted_zone_name" {
  type        = string
  description = "Route53 Hosted Zone to create"
}

output "bucket" {
  value       = aws_s3_bucket.artifact_store.bucket
  description = "S3 Bucket Artifact Store name"
}

output "hosted_zone_id" {
  value       = aws_route53_zone.dns.id
  description = "Hosted Zone ID"
}

output "hosted_zone_ns" {
  value       = aws_route53_zone.dns.primary_name_server
  description = "NS record for Hosted Zone"
}

output "hosted_zone_nss" {
  value       = aws_route53_zone.dns.name_servers
  description = "NS records for Hosted Zone"
}
