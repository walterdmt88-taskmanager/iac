locals {
  # Layer 1 — common tags applied to every resource in this env
  tags = {
    Project          = var.project
    Environment      = var.environment
    ResponsibleParty = var.responsible_party
    Owner            = var.owner
  }

  # Day 31 needs SSH in (k3s install) + 6443 reachable from laptop (kubectl).
  # Auto-detected so this stays correct without manual edits when your IP changes.
  my_cidr = "${chomp(data.http.my_ip.response_body)}/32"

  access_name = "${var.prefix}-${var.project}-${var.environment}-${var.region_code}-${var.purpose}"
}

data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

# Imports YOUR existing local public key — Terraform never touches the private key
resource "aws_key_pair" "day31" {
  key_name   = "${local.access_name}-key"
  public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
  tags       = local.tags
}

resource "aws_security_group" "day31" {
  name        = "${local.access_name}-sg"
  description = "SSH (22) + k3s API (6443), scoped to my current IP only"

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_cidr]
  }

  ingress {
    description = "k3s API from my IP"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [local.my_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, { Name = "${local.access_name}-sg" })
}

# SSM Session Manager was attempted here (IAM-based access, immune to client IP
# drift) but walter-admin lacks iam:CreateRole / iam:ListRoles — blocked, same
# class of restriction as the ECR cross-account issue. See status.md "Blocked".
# The aws_ec2 module's iam_instance_profile_name input (below, unused for now)
# is left in place so this is a one-line wire-up once an admin creates the role.

module "api_server" {
  source = "../modules/aws_ec2"

  # Standard 6 — every module gets these
  prefix      = var.prefix
  project     = var.project
  environment = var.environment
  region_code = var.region_code
  region      = var.region
  tags        = merge(local.tags, { Day = "31" })

  # EC2-specific
  purpose                = var.purpose
  instance_type          = var.instance_type
  ami_id                 = "ami-03a70db2d8c756040" # pinned 2026-08-25 — see aws_ec2/variables.tf for why
  key_name               = aws_key_pair.day31.key_name
  vpc_security_group_ids = [aws_security_group.day31.id]
}