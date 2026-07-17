# ===== STANDARD MODULE CONTRACT (every module takes these) =====

variable "prefix" {
  description = "Org or customer shortcode used in resource names (e.g. 'proops')"
  type        = string
}

variable "project" {
  description = "Project shortcode (e.g. 'blogcms')"
  type        = string
}

variable "environment" {
  description = "Environment name: dev / test / prod"
  type        = string
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be one of: dev, test, prod."
  }
}

variable "region_code" {
  description = "Compact region code (e.g. 'apse2' for ap-southeast-2)"
  type        = string
}

variable "region" {
  description = "Full AWS region name (e.g. 'ap-southeast-2'). Used by data sources."
  type        = string
}

variable "tags" {
  description = "Common tags applied to every resource (Project, Environment, ResponsibleParty, Owner)"
  type        = map(string)
}

# ===== EC2-SPECIFIC INPUTS =====

variable "purpose" {
  description = "What this EC2 is for — used in the name suffix (e.g. 'api-server', 'vpn')"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to attach"
  type        = list(string)
  default     = []
}

variable "subnet_id" {
  description = "Subnet ID where the instance is launched"
  type        = string
  default     = null
}