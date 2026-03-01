# VPC

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "instance_tenancy" {
  description = "Tenancy option for instances launched into the VPC (default or dedicated)."
  type        = string
  default     = "default"

  validation {
    condition     = contains(["default", "dedicated"], var.instance_tenancy)
    error_message = "instance_tenancy must be 'default' or 'dedicated'."
  }
}

variable "enable_dns_support" {
  description = "Whether to enable DNS support in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Whether to enable DNS hostnames in the VPC."
  type        = bool
  default     = true
}


# Availability zones and subnet tiers


variable "availability_zones" {
  description = "List of availability zone names (e.g. eu-west-2a, eu-west-2b). Used for public, web, and database subnets."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 1 
    error_message = "availability_zones must contain at least 1 zone."
  }
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets (one per availability zone, in same order as availability_zones)."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidr_blocks) == length(var.availability_zones)
    error_message = "public_subnet_cidr_blocks must have the same length as availability_zones."
  }
}

variable "web_subnet_cidr_blocks" {
  description = "CIDR blocks for web (private) subnets (one per availability zone, in same order as availability_zones)."
  type        = list(string)

  validation {
    condition     = length(var.web_subnet_cidr_blocks) == length(var.availability_zones)
    error_message = "web_subnet_cidr_blocks must have the same length as availability_zones."
  }
}

variable "database_subnet_cidr_blocks" {
  description = "CIDR blocks for database (private) subnets (one per availability zone, in same order as availability_zones)."
  type        = list(string)

  validation {
    condition     = length(var.database_subnet_cidr_blocks) == length(var.availability_zones)
    error_message = "database_subnet_cidr_blocks must have the same length as availability_zones."
  }
}

variable "map_public_ip_on_launch_public" {
  description = "Whether to assign a public IP to instances launched in public subnets."
  type        = bool
  default     = true
}

# Naming and tags

variable "tags" {
  description = "Map of tags to apply to all networking resources."
  type        = map(string)
  default     = {}
}

variable "environment_name" {
  description = "The environment name"
  type        = string
}

variable "region" {
  description = "The region"
  type        = string
}