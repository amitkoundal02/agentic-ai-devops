######### Elastic IP #########
# Recommended for NAT so the public IP stays stable across reboots
resource "aws_eip" "nat_eip" {
  instance = aws_instance.nat_instance.id
  tags = merge(local.common_tags, {
    Name = "${var.project_name}_${var.environment}_nat_eip"
  })
}