# ========================================
# Terraform & Provider Configuration
# ========================================
# AWS provider v6.51.0 pinned for stability

terraform {
  required_version = "v1.15.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.51.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      ManagedBy = "Terraform"
    }
  }
}