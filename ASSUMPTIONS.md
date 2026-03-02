# Assumptions

This document outlines the key assumptions made in the Terraform solution.

## Infrastructure & AWS

1. **AWS Account & Credentials**
   - AWS account exists with appropriate IAM permissions
   - AWS CLI is configured with valid credentials
   - User has permissions to create: VPC, subnets, route tables, NAT gateways, ALB, ECS, RDS, IAM, KMS, Secrets Manager, CloudWatch

2. **AWS Region**
   - Primary region: `eu-west-2` (London)
   - Can be overridden via `terraform.tfvars.json` or environment variables
   - ECS Fargate is available in the selected region (most AWS regions support Fargate)

3. **Availability Zones**
   - Default: `eu-west-2a` and `eu-west-2b` (2 AZs for HA)
   - Solution supports 2-3 AZs; can be extended via `var.availability_zones`

## Network Design

4. **VPC CIDR Block**
   - Default: `10.0.0.0/16` (65,536 IP addresses)
   - Provides enough space for 3 subnet tiers across multiple AZs
   - No overlaps with other VPCs or on-premises networks

5. **Subnet Architecture (3-Tier)**
   - **Public Subnets** (`10.0.1.0/24`, `10.0.2.0/24`): NAT gateways, bastion hosts, ALB
   - **Web Subnets** (`10.0.10.0/24`, `10.0.11.0/24`): ECS Fargate tasks (private)
   - **Database Subnets** (`10.0.20.0/24`, `10.0.21.0/24`): RDS instances (private)
   - All subnets are /24 (256 addresses) - sufficient for development/small production

6. **High Availability (HA)**
   - NAT Gateway deployed in **one** public subnet per AZ
   - Multiple ECS tasks across private subnets in different AZs
   - RDS Multi-AZ can be enabled (default: single-AZ for dev cost optimization)
   - ALB spans all public subnets for redundancy

## Container & Compute

7. **Container Runtime**
   - **ECS Fargate** (serverless containers)
   - Default image: `nginx:1.25.3-alpine` (lightweight, production-ready)
   - Container port: 80 (HTTP)
   - Task CPU: 256 units, Memory: 512 MB (compatible with Fargate)

8. **ECS Service**
   - Default desired count: 1 task (dev environment cost optimization; controlled via `desired_count` variable)
   - Auto-scaling: disabled by default (enable in variables if needed)
   - Launch type: Fargate (no EC2 instances to manage)

9. **IAM & Permissions**
   - ECS Execution Role: can pull images from ECR, write logs to CloudWatch, assume KMS permissions
   - ECS Task Role: minimal permissions (can be extended per application needs)
   - No hardcoded credentials in code (uses IAM roles)

## Database

10. **Database Engine**
    - Default: PostgreSQL (latest 15.x or whatever version is available in the region)
    - Supports: MySQL 8.0+ (configurable via variables)
    - Instance type: `db.t3.micro` (burstable, cost-effective for dev)
    - Allocated storage: 20 GB (scalable)

11. **Database Security**
    - **Storage encryption**: KMS-managed (encryption at rest)
    - **Credentials**: auto-generated random password stored in AWS Secrets Manager
    - **Network**: in private subnets, only accessible from ECS security group
    - **Backups**: 1-day retention for dev (can be increased for prod)
    - **Deletion protection**: disabled for dev (enabled for prod)

12. **Database Availability**
    - Single-AZ deployment for dev (cost optimization)
    - Multi-AZ can be enabled for production
    - No read replicas configured (can be added if needed)

## Load Balancing

13. **Application Load Balancer**
    - Type: Application Load Balancer (ALB) - optimal for HTTP/HTTPS
    - Target type: IP (required for Fargate)
    - Health check: HTTP GET `/` every 30 seconds
    - Protocol: HTTP only (default - HTTPS can be added with certificate)

14. **Security Groups**
    - **ALB SG**: allows inbound HTTP (0.0.0.0/0) on port 80
    - **ECS SG**: allows inbound from ALB SG only on port 80
    - **Database SG**: allows inbound from ECS SG only on port 5432/3306

## Logging & Monitoring

15. **CloudWatch Logs**
    - Log group: `/ecs/{environment}-{service}`
    - Log retention: 7 days (dev default, configurable)
    - All container stdout/stderr automatically captured
    - Log driver: awslogs (CloudWatch Logs)

16. **Container Insights**
    - Disabled by default (optional, adds cost)
    - Can be enabled for detailed ECS metrics
    - Requires specific IAM permissions

## Terraform & State Management

17. **Terraform Version**
    - Required: >= 1.0
    - AWS Provider: >= 4.0
    - HCL2 syntax with modern features (for_each, dynamic blocks)

18. **State Management**
    - Default: **local state** (development only)
    - Not suitable for team collaboration or production
    - **Recommendation**: Configure S3 backend with DynamoDB locking for shared environments

19. **Module Structure**
    - 4 independent modules: networking, compute, loadbalancer, database
    - Each module has its own variables, outputs, versions.tf
    - Root module in `environments/dev/` orchestrates them
    - Relative module paths: `../../modules/{module_name}`

## Environment Strategy

20. **Environment Separation**
    - Separate directories: `dev/`, `prod/` under `environments/`
    - Each environment has its own `terraform.tfvars.json`
    - Allows different configurations (instance types, scaling, multi-az) per environment

21. **Default Values**
    - All variables have sensible defaults for development
    - Production configs should override with larger instance types, HA, deletion protection
    - Resource naming convention: `{environment}-{service}-{resource_type}`

## Limitations & Known Constraints

23. **No HTTPS**
    - Default configuration uses HTTP only
    - HTTPS requires ACM certificate (can be added in loadbalancer module)

24. **No VPN/Bastion**
    - No VPN gateway or bastion host included
    - Private subnets are internet-isolated (SSM Session Manager can be used instead)

25. **Cost Considerations**
    - Multi-AZ RDS, NAT gateways, and ECS scaling increase costs
    - Dev config optimized for minimal cost (single AZ, t3.micro)
    - Review AWS pricing for production deployments

## Prerequisites

26. **Local Tools**
    - Terraform CLI (>= 1.0)
    - AWS CLI configured
    - Sufficient AWS credits/budget for provisioning

27. **Terraform Working Directory**
    - Must cd into `environments/dev/` or `environments/prod/`
    - Terraform will find modules via relative `../../modules/...` paths

---

## Next Steps

To use this solution:
1. Customize `environments/dev/terraform.tfvars.json` for your needs
2. Configure remote state (S3 backend) for team collaboration
3. Run `terraform plan` to review resources
4. Run `terraform apply` to provision infrastructure
5. Access ALB DNS name from outputs to test the application
