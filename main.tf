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
  region = "us-east-1"

  default_tags {
    tags = {
      env     = var.env
      owner   = "SRE"
      project = "static-site-fancy"
    }
  }
}

data "aws_caller_identity" "current" {}

variable "hosted_zone_id" {
  type        = string
  description = "Target Route53 Hosted Zone"
}

variable "env" {
  type        = string
  description = "Current Environment"
}

variable "subdomain" {
  type        = string
  description = "Current Subdomain"
  nullable    = true
}

variable "artifact_version" {
  type        = string
  description = "Current Artifact Version"
}

variable "bucket" {
  type        = string
  description = "Source S3 Bucket"
}

output "url" {
  value = format("https://%s", local.hostname)
}
