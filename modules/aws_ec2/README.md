# aws_ec2 module

Wraps `terraform-aws-modules/ec2-instance/aws` with proops2026 naming + tagging conventions.

## Usage

```hcl
module "api_server" {
  source = "../modules/aws_ec2"

  prefix      = "proops"
  project     = "blogcms"
  environment = "dev"
  region_code = "apse2"
  region      = "ap-southeast-2"
  purpose     = "api-server"

  instance_type          = "t3.small"
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.sg.id]

  tags = local.tags
}
```

## Inputs

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| prefix | Org / customer shortcode | string | - | yes |
| project | Project shortcode | string | - | yes |
| environment | dev / test / prod | string | - | yes |
| region_code | Compact region (apse2) | string | - | yes |
| region | Full AWS region | string | - | yes |
| purpose | Suffix in resource name | string | - | yes |
| instance_type | EC2 type | string | t3.micro | no |
| subnet_id | Subnet ID | string | null | no |
| vpc_security_group_ids | Security group IDs | list(string) | [] | no |
| tags | Common tags (Project, Environment, ResponsibleParty, Owner) | map(string) | - | yes |

## Outputs

| Name | Description |
|---|---|
| instance | Full ec2-instance module object |
| id | EC2 instance ID |
| public_ip | Public IP |
| private_ip | Private IP |
| name | Generated resource name |

## Naming convention applied

Resources created by this module are named:
\`{prefix}-{project}-{environment}-ec2-{region_code}-{purpose}\`

Example: \`proops-blogcms-dev-ec2-apse2-api-server\`