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

variable "eks_subnets" {
  description = "Map of EKS subnet configurations"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))

  # Validate CIDR format
  validation {
    condition = alltrue([
      for s in values(var.eks_subnets) : can(cidrhost(s.cidr_block, 0))
    ])
    error_message = "All EKS subnet cidr_block values must be valid CIDR blocks (e.g. 10.0.1.0/24)."
  }

  # Validate AZs are unique across subnets
  validation {
    condition = length([
      for s in values(var.eks_subnets) : s.availability_zone
      ]) == length(distinct([
        for s in values(var.eks_subnets) : s.availability_zone
    ]))
    error_message = "Availability zones must be unique across EKS subnets."
  }

  # Validate AZs exist in the current region
  validation {
    condition = alltrue([
      for s in values(var.eks_subnets) : contains(local.available_azs, s.availability_zone)
    ])
    error_message = "One or more EKS subnet availability zones are not valid for this region."
  }
}