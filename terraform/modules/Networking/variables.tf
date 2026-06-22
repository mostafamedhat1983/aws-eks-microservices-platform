variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string

  # Validates CIDR format by attempting to calculate the first IP; can() catches errors if invalid
  validation {
    condition     = can(cidrhost(var.vpc_cidr_block, 0))
    error_message = "Must be a valid CIDR block (e.g. 10.0.0.0/16)."
  }
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "microservices-platform"
}

variable "availability_zones" {
  type        = list(string)
  description = " AZs used in the project"
  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "Provide at least 2 availability zones."
  }

  validation {
    condition     = length(var.availability_zones) == length(distinct(var.availability_zones))
    error_message = "Availability zones must be unique."
  }

  validation {
    condition = alltrue([
      for az in var.availability_zones : contains(local.available_azs, az)
    ])
    error_message = "One or more AZs are not valid for this region."
  }
}