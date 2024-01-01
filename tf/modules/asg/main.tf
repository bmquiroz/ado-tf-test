# data "aws_ami" "ami" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"]
# }

data "aws_ssm_parameter" "ami" {
  name = var.ssm_parameter_name
}

resource "aws_launch_template" "blue-template" {
  name = var.blue_template_name
  image_id = data.aws_ssm_parameter.ami.value
  instance_type = var.instance_type
  key_name = var.aws_key_pair

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

resource "aws_launch_template" "green-template" {
  name = var.green_template_name
  image_id = data.aws_ssm_parameter.ami.value
  instance_type = var.instance_type
  key_name = var.aws_key_pair

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

resource "aws_autoscaling_group" "blue-green-asg" {
  name                      = var.asg_name
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.capacity
  vpc_zone_identifier       = var.aws_subnet_compute_id

  launch_template {
    # id      = aws_launch_template.green-template.id
    # version = aws_launch_template.green-template.latest_version

    id      = var.deployment_color == "green" ? aws_launch_template.green-template.id : aws_launch_template.blue-template.id
    version = var.deployment_color == "green" ? aws_launch_template.green-template.latest_version : aws_launch_template.blue-template.latest_version
  }
}