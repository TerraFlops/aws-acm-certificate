variable "hosted_zone_id" {
  description = "HostedZone where ACM Validation records are to be created."
  type = string
}

variable "domain_name" {
  description = "The domain name for which the certificate should be issued."
  type = string
}

variable "subject_alternative_names" {
  description = "Set of domains that should be SANs in the issued certificate. To remove all elements of a previously configured list, set this value equal to an empty list ([]) or use the terraform taint command to trigger recreation."
  type = set(string)
  default = []
}
