variable "backend-bucket" {
  type        = string
  default     = "rcits-terraform"
}

variable "backend-key" {
  type        = string
  default     = "ado-tf-test"
}

variable "backend-region" {
  type = string
  default = "us-east-1"
}