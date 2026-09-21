######### Internet Gateway #########
resource "aws_internet_gateway" "egp_igw" {
  vpc_id = aws_vpc.egp_vpc.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}_${var.environment}_igw"
  })

}

