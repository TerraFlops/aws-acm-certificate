variable "hosted_zone_id" {
  description = "Hosted zone ID in which the certificate validation record will be created"
  type = string
}

variable "domain_name" {
  description = "Certificate domain name"
  type = string
}

variable "subject_alternative_names" {
  description = "Optional list of alternate subject names and their Hosted Zone IDs to be added to the certificate"
  type = list(object({
    name = string
    hosted_zone_id = string
  }))
  default = []
}
