# Core Deployment Information
# variable "env" { type = string }

# variable "application" { type = string }

# variable "uai" { type = string }

# variable "aws_region" { type = string }

# variable "aws_availability_zones" { type = list(any) }

# variable "ip_subnets" { type = map(any) }

variable "aws_subnet_compute_id" { type = list(any) }

# variable "tagging_standard" { type = map(any) }

# variable "aws_vpc_main_id" { type = string }

# variable "vpc_cidr" { type = string }

# variable "aws_subnet_public_id" { type = list(any) }

# variable "aws_kms_key_tableau1_arn" { type = string }

# variable "aws_iam_instance_profile_name" { type = string }

variable "aws_key_pair" { type = string }

# variable "instance_ec2_settings" { type = map(any) }

# variable "trusted_cidrs" { type = list }

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}

variable "ssm_parameter_name" {
  type        = string
  default     = null
}

variable "blue_template_name" {
  type        = string
  default     = null
}

variable "green_template_name" {
  type        = string
  default     = null
}

variable "asg_name" {
  type        = string
  default     = null
}

variable "network_interfaces" {
  description = "Customize network interfaces to be attached at instance boot time"
  type        = list(any)
  default     = []
}