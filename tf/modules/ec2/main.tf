# resource "aws_network_interface" "instance" {
#   count = lookup(var.instance_ec2_settings, "instance_count")
#   subnet_id       = element(var.aws_subnet_public_id, count.index % length(var.aws_subnet_public_id))
#   private_ips     = [cidrhost(lookup(var.ip_subnets, "subnet_public${count.index % length(var.aws_subnet_public_id)}"), 4 + floor(count.index / length(var.aws_subnet_public_id)))]
#   security_groups = [aws_security_group.instance.id]

#   tags = merge(
#     var.tagging_standard,
#     map("Name", "${lookup(var.tagging_standard, "deployment")}-instance${count.index + 1}")
#   )
# }

resource "aws_iam_role" "instance-role" {
  name = "rcits-poc-ssm-ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "instance-profile" {
  name = "rcits-poc-ssm-ec2-profile"
  role = "${aws_iam_role.instance-role.id}"
}

resource "aws_iam_policy_attachment" "instance-policy-attach1" {
  name       = "instance-ssm-attachment1"
  roles      = [aws_iam_role.instance-role.id]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy_attachment" "instance-policy-attach2" {
  name       = "instance-ssm-attachment2"
  roles      = [aws_iam_role.instance-role.id]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_policy_attachment" "instance-policy-attach3" {
  name       = "instance-ssm-attachment3"
  roles      = [aws_iam_role.instance-role.id]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_instance" "instance" {
  count = lookup(var.instance_ec2_settings, "instance_count")
  ami                  = lookup(var.instance_ec2_settings, "ami")
  instance_type        = lookup(var.instance_ec2_settings, "instance_type")
  key_name             = var.aws_key_pair
  monitoring           = true
  ebs_optimized        = true
  vpc_security_group_ids = [aws_security_group.instance-sg.id]
  subnet_id            = "${element(var.aws_subnet_compute_id,0)}"
  iam_instance_profile = "${aws_iam_instance_profile.instance-profile.id}"
  associate_public_ip_address = var.associate_public_ip_address
  # user_data            = "${file("bootstrap.sh")}"

  # metadata_options {
  #   http_endpoint = "enabled"
  #   http_tokens   = "required"
  # }

  root_block_device {
    # encrypted   = true
    # kms_key_id  = var.aws_kms_key_tableau1_arn
    volume_size = lookup(var.instance_ec2_settings, "volume_size")
    volume_type = lookup(var.instance_ec2_settings, "volume_type")
  }

  # network_interface {
  #   network_interface_id = aws_network_interface.instance[count.index].id
  #   device_index         = 0
  # }
  tags = merge(
    var.tagging_standard, 
    tomap({"Name" = "${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-instance${count.index + 1}"})
  )
}