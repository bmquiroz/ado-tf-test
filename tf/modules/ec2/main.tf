resource "aws_instance" "instance" {
  count = lookup(var.instance_ec2_settings, "instance_count")
  ami                  = lookup(var.instance_ec2_settings, "ami")
  instance_type        = lookup(var.instance_ec2_settings, "instance_type")
  key_name             = var.aws_key_pair
  monitoring           = true
  ebs_optimized        = true
  vpc_security_group_ids = [aws_security_group.instance-sg.id]
  subnet_id            = "${element(var.aws_subnet_compute_id,0)}"
  associate_public_ip_address = var.associate_public_ip_address
  user_data            = "${file("bootstrap.sh")}"

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