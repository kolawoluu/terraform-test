# Networking Module

Creates a VPC with public, web (private), and database (private) subnets across multiple availability zones. One NAT gateway per AZ is created for private subnet outbound traffic.

## Features

- **VPC** — Configurable CIDR, DNS support/hostnames, tenancy
- **Public subnets** — Internet Gateway, optional public IP on launch
- **Web (private) subnets** — One NAT gateway per AZ for outbound traffic
- **Database (private) subnets** — No internet route (for RDS, etc.)
- **Route tables** — Public (IGW), web (NAT per AZ), database (local only)
- **Tagging** — Applied to all resources; `for_each` over AZs (1–3)

## Usage

```hcl
module "networking" {
  source = "../../modules/networking"

  environment_name = "dev"
  region           = "eu-west-2"

  vpc_cidr_block             = "10.0.0.0/16"
  availability_zones         = ["eu-west-2a", "eu-west-2b"]
  public_subnet_cidr_blocks   = ["10.0.1.0/24", "10.0.2.0/24"]
  web_subnet_cidr_blocks      = ["10.0.10.0/24", "10.0.11.0/24"]
  database_subnet_cidr_blocks = ["10.0.20.0/24", "10.0.21.0/24"]

  tags = { Environment = "dev" }
}
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `environment_name` | Environment name (e.g. dev, prod) | `string` | required |
| `region` | AWS region | `string` | required |
| `vpc_cidr_block` | VPC CIDR block | `string` | required |
| `availability_zones` | List of AZ names (e.g. eu-west-2a, eu-west-2b) | `list(string)` | required |
| `public_subnet_cidr_blocks` | CIDRs for public subnets (one per AZ) | `list(string)` | required |
| `web_subnet_cidr_blocks` | CIDRs for web/private subnets (one per AZ) | `list(string)` | required |
| `database_subnet_cidr_blocks` | CIDRs for database subnets (one per AZ) | `list(string)` | required |
| `instance_tenancy` | VPC tenancy (default or dedicated) | `string` | `"default"` |
| `enable_dns_support` | Enable DNS support in VPC | `bool` | `true` |
| `enable_dns_hostnames` | Enable DNS hostnames in VPC | `bool` | `true` |
| `map_public_ip_on_launch_public` | Assign public IP in public subnets | `bool` | `true` |
| `tags` | Tags for all resources | `map(string)` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| `vpc_id` | VPC ID |
| `vpc_cidr_block` | VPC CIDR block |
| `public_subnet_ids` | List of public subnet IDs |
| `public_subnet_id_by_az` | Map of AZ index → public subnet ID |
| `web_subnet_ids` | List of web/private subnet IDs |
| `web_subnet_id_by_az` | Map of AZ index → web subnet ID |
| `database_subnet_ids` | List of database subnet IDs |
| `database_subnet_id_by_az` | Map of AZ index → database subnet ID |
| `internet_gateway_id` | Internet Gateway ID |
| `nat_gateway_ids` | List of NAT Gateway IDs (one per AZ) |
| `public_route_table_id` | Public route table ID |
| `availability_zones` | List of AZs in use |

Use `public_subnet_ids` for ALB, `web_subnet_ids` for ECS/app, `database_subnet_ids` for RDS subnet group.

## Requirements

- Terraform >= 1.5
- AWS provider >= 5.0

## Notes

- Each CIDR list (`public_subnet_cidr_blocks`, `web_subnet_cidr_blocks`, `database_subnet_cidr_blocks`) must have the same length as `availability_zones` (validation enforced).
- `availability_zones` must contain at least 1 zone.
