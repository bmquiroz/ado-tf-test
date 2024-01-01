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
}

module "asg-blue-green-deploy" {
  source                      = "../../modules/asg"
  # env                         = "sandbox"
  # application                 = "rcits"
  # uai                         = "123"
  # aws_region                 = "us-east-1"
  aws_subnet_compute_id       = ["subnet-047543b5ae3b70ee4"]
  aws_key_pair                = "rcits-poc-key1"
  ssm_parameter_name          = "win-2019-v1"
  blue_template_name          = "rcits-blue-template"
  green_template_name         = "rcits-green-template"
  asg_name                    = "rcits-blue-green-asg"
  instance_type               = "t2.micro"
  max_size                    = 4
  min_size                    = 2
  capacity                    = 4
  network_interfaces          = [{security_groups = ["sg-01e52f58d04156a9c"]}]
  deployment_color            = "blue"
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