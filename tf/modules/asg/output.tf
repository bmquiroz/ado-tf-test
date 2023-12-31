/*output "aws_eip_bastion_public_ip" {
  value = aws_eip.bastion.*.public_ip
}*/

output "instance-sg" {
  value = aws_security_group.instance-sg.id
}