# variable "env" { type = string }

# variable "application" { type = string }

# variable "uai" { type = string }

# variable "aws_region" { type = string }

# variable "aws_availability_zones" { type = list(any) }

# variable "ip_subnets" { type = map(any) }

# variable "instance_ec2_settings" { type = map(any) }

variable "tagging_standard" { type = map(any) }

variable "aws_subnet_compute_id" { type = list(any) }

variable "aws_key_pair" { type = string }

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}

variable "ssm_parameter_name" {
  type        = string
  default     = null
}

variable "instance_type" {
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

variable "max_size" {
  type        = number
  default     = null
}

variable "min_size" {
  type        = number
  default     = null
}

variable "capacity" {
  type        = number
  default     = null
}

variable "deployment_color" {
  type        = string
  default     = null
}

variable "vpc_id" {
  type        = string
  default     = null
}