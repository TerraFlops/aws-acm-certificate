# Terraflops Terraform Module
 
### AWS ACM Certificate

This module creates an AWS ACM Certificate and associated DNS validation records in Route 53.

#### Example usage

```hcl-terraform
module "example_com_certificate" {
  source = "git::https://github.com/TerraFlops/aws-acm-certificate.git"
  domain_name = "example.com"
  hosted_zone_id = data.aws_route53_zone.example.zone_id
  subject_alternative_names = [
    "api.example.com",
    "*.api.example.com"
  ]
}
```
