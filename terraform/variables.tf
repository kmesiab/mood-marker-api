variable "region" {
  type = string
  default = "us-west-2"
}

variable "deployment_bucket_name" {
  type = string
  default = "mood-marker-api-lambda-deployments"
}

variable "route_53_hosted_zone_id" {
  type = string
  default = "Z00098522Y9LE2926BSFR"
}