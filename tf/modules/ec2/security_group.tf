resource "aws_security_group" "instance-sg" {
  name = "${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-instance-sg"
  lifecycle {
    create_before_destroy = "true"
  }
  description = "Security Group for servers"
  vpc_id      = var.aws_vpc_main_id
}

# Allow all outbound traffic
resource "aws_security_group_rule" "instance-sg-egress" {
  security_group_id = aws_security_group.instance-sg.id
  description       = "Allow all egress"

  type        = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "instance-sg-general-ingress" {
  security_group_id = aws_security_group.instance-sg.id
  description       = "Allow traffic from VPC CIDR to instance"

  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = [var.vpc_cidr]
}