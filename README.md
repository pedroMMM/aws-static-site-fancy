# "Fancy" Static Site Hosting on AWS 

## Problem Statement

Write a Terraform module for generating the infrastructure needed for hosting a static website/app on AWS.

### The code should include resources for:
- Storing the static site content
- Serving the content with a CDN
- Providing hosted zone and cname for the site

### The solution should support:
- Creating multiple separate environments - E.g. make it easy to deploy to new environments without manual work in AWS UI
- Reuse without changing/removing hard-coded strings within the resource blocks
- Providing inputs/outputs so that the code could be invoked from a CI or other system

### Extra credit for...
- Cloudwatch resources to help monitor the site
- WAF for providing additional security capabilities
- Log delivery to S3/Athena for downstream analysis
- Integration (even partial) with any of the AWS Code* CI/CD tools
