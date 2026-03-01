# Local values for consistent naming and iteration

locals {

  common_tags = merge(var.tags, {
    "Module" = "networking"
  })

  # AZs as a map keyed by index for for_each (avoids dependency on AZ names in keys)
  azs = {
    for i, az in var.availability_zones : i => {
      name   = az
      suffix = substr(az, -1, 1) # e.g. "a" from "eu-west-2a"
    }
  }

  # Subnet tier names for resource naming
  public_subnet_names   = { for k, v in local.azs : k => "public-${v.suffix}" }
  web_subnet_names      = { for k, v in local.azs : k => "web-${v.suffix}" }
  database_subnet_names = { for k, v in local.azs : k => "database-${v.suffix}" }
}
