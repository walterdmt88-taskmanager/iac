locals {
  # Layer 1 — common tags applied to every resource in this env
  tags = {
    Project          = var.project
    Environment      = var.environment
    ResponsibleParty = var.responsible_party
    Owner            = var.owner
  }
}

module "api_server" {
  source = "../modules/aws_ec2"

  # Standard 6 — every module gets these
  prefix      = var.prefix
  project     = var.project
  environment = var.environment
  region_code = var.region_code
  region      = var.region
  tags        = local.tags

  # EC2-specific
  purpose       = var.purpose
  instance_type = var.instance_type
}