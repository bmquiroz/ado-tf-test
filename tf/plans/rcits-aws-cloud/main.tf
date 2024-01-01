terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = var.backend-bucket
    key    = var.backend-key
    region = var.backend-region
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "default"
#   assume_role {
#   role_arn = "arn:aws:iam::000000:role/rcits-explorer"
#     }
}

module "asg-blue-green-deploy" {
  source                      = "../../modules/asg"
  # env                         = "sandbox"
  # application                 = "rcits"
  # uai                         = "123"
  # aws_region                 = "us-east-1"
  aws_subnet_compute_id       = ["subnet-047543b5ae3b70ee4"]
  # aws_vpc_main_id             = "vpc-03d790a49d55d25c2"
  aws_key_pair                = "rcits-poc-key1"
  # vpc_cidr                    = "10.0.0.0/16"
  # associate_public_ip_address = true
  ssm_parameter_name          = "win-2019-v1"
  blue_template_name          = "rcits-blue-template-v1"
  asg_name                    = "rcits-blue-green-asg"
  network_interfaces          = [{security_groups = ["sg-045a986bf9cd39133"]}]
  # tagging_standard            =  {
  #                               "deployment"  = "sandbox"
  #                               "patch" = "yes"
  #                               "tag2" = "tag2"
  #                               }
  # instance_ec2_settings       =  {
  #                               "ami"  = "ami-093693792d26e4373"
  #                               "instance_type" = "t3.small"
  #                               "instance_count" = "1"
  #                               "volume_size" = "50"
  #                               "volume_type" = "gp2"
  #                               }

  # depends_on = [
  #   module.base-infra
  # ]
}