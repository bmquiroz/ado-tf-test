terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "default"
#   assume_role {
#   role_arn = "arn:aws:iam::000000:role/rcits-explorer"
#     }
}

# module "bastion-host" {
#   source                     = "../../modules/ec2"
#   env                        = "sandbox"
#   application                = "rcits"
#   uai                        = "123"
#   # aws_region                 = "us-east-1"
#   aws_subnet_compute_id      = module.base-infra.aws-subnet-compute-id
#   aws_vpc_main_id            = module.base-infra.aws-vpc-main-id
#   aws_key_pair               = "rcits-poc-bastion-key"
#   vpc_cidr                   = "10.0.0.0/16"
#   tagging_standard           =  {
#                                 "deployment"  = "sandbox"
#                                 "tag1" = "tag1"
#                                 "tag2" = "tag2"
#                                 }
#   bastion_ec2_settings       =  {
#                                 "ami"  = "ami-00e87074e52e6c9f9"
#                                 "instance_type" = "t3.small"
#                                 "instance_count" = "1"
#                                 "volume_size" = "50"
#                                 "volume_type" = "gp2"
#                                 }

#   depends_on = [
#     module.base-infra
#   ]
# }

module "ssm-managed-host" {
  source                      = "../../modules/ec2"
  env                         = "sandbox"
  application                 = "rcits"
  uai                         = "123"
  # aws_region                 = "us-east-1"
  aws_subnet_compute_id       = ["subnet-047543b5ae3b70ee4"]
  aws_vpc_main_id             = "vpc-03d790a49d55d25c2"
  aws_key_pair                = "rcits-poc-key1"
  vpc_cidr                    = "10.0.0.0/16"
  associate_public_ip_address = true
  tagging_standard            =  {
                                "deployment"  = "sandbox"
                                "patch" = "yes"
                                "tag2" = "tag2"
                                }
  instance_ec2_settings       =  {
                                "ami"  = "ami-093693792d26e4373"
                                "instance_type" = "t3.small"
                                "instance_count" = "1"
                                "volume_size" = "50"
                                "volume_type" = "gp2"
                                }

  # depends_on = [
  #   module.base-infra
  # ]
}