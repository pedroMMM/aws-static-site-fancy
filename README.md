# "Fancy" Static Site Hosting Terraform Module on AWS 

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

## Local Development

AWS resources for Terraform Module local development are under the `local` directory,

1. Copy `pedro.tfvars` file naming it after the user.
1. Modify the new file to create a new subdomain on a domain you control.
1. Run Terraform via: 
    1. Prepare Terraform using `terraform init`
    1. Plan the Terraform changes and review using `terraform plan -var-file <yourname>.tfvars -out tfplan`
    1. Apply Terraform changes via `terraform apply tfplan`
1. Add a NS records on the domain your control for the new Route53 Hosted Zone. The NS record should have the same name as your Hosted Zone. Use the Terraform output for the answers, depending on the DNS host it can a single or multiple answers.

