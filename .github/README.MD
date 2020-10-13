# Terraflops Terraform Module
 
### AWS ACM Certificate

This module creates an AWS ACM Certificate and associated DNS validation records in Route 53.

#### Example usage

```hcl-terraform
module "acm_certificate" {
  source = "git::https://github.com/TerraFlops/aws-acm-certificate?ref=v2.0"
  providers = {
    aws = aws.us_east_1
  }

  hosted_zone_id = "Z0493816xxxxxxxVRGQN"
  domain_name = "example.com.au"
  subject_alternative_names = [
    "example.com",
    "example.net"
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| aws | >= 0.13.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 0.13.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domain\_name | The domain name for which the certificate should be issued. | `string` | n/a | yes |
| hosted\_zone\_id | HostedZone where ACM Validation records are to be created. | `string` | n/a | yes |
| subject\_alternative\_names | Set of domains that should be SANs in the issued certificate. To remove all elements of a previously configured list, set this value equal to an empty list ([]) or use the terraform taint command to trigger recreation. | `set(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the certificate |
| domain\_name | The domain name for which the certificate is issued |
| domain\_validation\_options | Set of domain validation objects which can be used to complete certificate validation. Can have more than one element, e.g. if SANs are defined. Only set if DNS-validation was used. |
| id | The ID of the certificate |
| status | Status of the certificate. |

