data "aws_ssm_parameter" "ami" {
  name = var.ssm_parameter_name
}

resource "aws_launch_template" "blue-template" {
  name = var.blue_template_name

  # block_device_mappings {
  #   device_name = "/dev/sdf"

  #   ebs {
  #     volume_size = 20
  #   }
  # }

  # capacity_reservation_specification {
  #   capacity_reservation_preference = "open"
  # }

  # cpu_options {
  #   core_count       = 4
  #   threads_per_core = 2
  # }

  # credit_specification {
  #   cpu_credits = "standard"
  # }

  # disable_api_stop        = true
  # disable_api_termination = true

  # ebs_optimized = true

  # elastic_gpu_specifications {
  #   type = "test"
  # }

  # elastic_inference_accelerator {
  #   type = "eia1.medium"
  # }

  # iam_instance_profile {
  #   name = "test"
  # }

  image_id = data.aws_ssm_parameter.ami.value

  # instance_initiated_shutdown_behavior = "terminate"

  # instance_market_options {
  #   market_type = "spot"
  # }

  instance_type = "t2.micro"

  # kernel_id = "test"

  key_name = var.aws_key_pair

  # license_specification {
  #   license_configuration_arn = "arn:aws:license-manager:eu-west-1:123456789012:license-configuration:lic-0123456789abcdef0123456789abcdef"
  # }

  # metadata_options {
  #   http_endpoint               = "enabled"
  #   http_tokens                 = "required"
  #   http_put_response_hop_limit = 1
  #   instance_metadata_tags      = "enabled"
  # }

  # monitoring {
  #   enabled = true
  # }

  # network_interfaces {
  #   associate_public_ip_address = true
  # }

  # placement {
  #   availability_zone = "us-west-2a"
  # }

  # ram_disk_id = "test"

  # vpc_security_group_ids = ["sg-12345678"]

  # tag_specifications {
  #   resource_type = "instance"

  #   tags = {
  #     Name = "test"
  #   }
  # }

  # user_data = filebase64("${path.module}/example.sh")

  dynamic "network_interfaces" {
    for_each = var.network_interfaces
    content {
      associate_carrier_ip_address = lookup(network_interfaces.value, "associate_carrier_ip_address", null)
      associate_public_ip_address  = lookup(network_interfaces.value, "associate_public_ip_address", null)
      delete_on_termination        = lookup(network_interfaces.value, "delete_on_termination", null)
      description                  = lookup(network_interfaces.value, "description", null)
      device_index                 = lookup(network_interfaces.value, "device_index", null)
      interface_type               = lookup(network_interfaces.value, "interface_type", null)
      ipv4_addresses               = try(network_interfaces.value.ipv4_addresses, [])
      ipv4_address_count           = lookup(network_interfaces.value, "ipv4_address_count", null)
      ipv6_addresses               = try(network_interfaces.value.ipv6_addresses, [])
      ipv6_address_count           = lookup(network_interfaces.value, "ipv6_address_count", null)
      network_interface_id         = lookup(network_interfaces.value, "network_interface_id", null)
      private_ip_address           = lookup(network_interfaces.value, "private_ip_address", null)
      security_groups              = lookup(network_interfaces.value, "security_groups", null)
      subnet_id                    = lookup(network_interfaces.value, "subnet_id", null)
    }
  }
}

# resource "aws_launch_template" "green-template" {
#   name_prefix   = "foobar"
#   image_id      = "ami-1a2b3c"
#   instance_type = "t2.micro"
# }

resource "aws_autoscaling_group" "blue-green-asg" {
  availability_zones        = ["us-east-1a"]
  name                      = var.asg_name
  max_size                  = 2
  min_size                  = 1
  # health_check_grace_period = 300
  # health_check_type         = "ELB"
  desired_capacity          = 2
  # force_delete              = true
  # placement_group           = aws_placement_group.test.id
  # launch_configuration      = aws_launch_configuration.foobar.name
  vpc_zone_identifier       = var.aws_subnet_compute_id

  # instance_maintenance_policy {
  #   min_healthy_percentage = 90
  #   max_healthy_percentage = 120
  # }

  # initial_lifecycle_hook {
  #   name                 = "foobar"
  #   default_result       = "CONTINUE"
  #   heartbeat_timeout    = 2000
  #   lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

  #   notification_metadata = jsonencode({
  #     foo = "bar"
  #   })

  #   notification_target_arn = "arn:aws:sqs:us-east-1:444455556666:queue1*"
  #   role_arn                = "arn:aws:iam::123456789012:role/S3Access"
  # }

#   tag {
#     key                 = "foo"
#     value               = "bar"
#     propagate_at_launch = true
#   }

#   timeouts {
#     delete = "15m"
#   }

#   tag {
#     key                 = "lorem"
#     value               = "ipsum"
#     propagate_at_launch = false
#   }
}