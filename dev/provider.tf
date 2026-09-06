terraform {
  required_version = "~> 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
  # PRODUCTION PATTERN — uncomment when you set up the state bucket (Explore Further):
  # backend "s3" {
  #   bucket = "proops2026-tfstate-shared"
  #   key    = "dev/terraform.tfstate"
  #   region = "ap-southeast-2"
  # }
  # For training today: leave local state (terraform.tfstate file in iac/dev/)
}

provider "aws" {
  region = var.region
}
