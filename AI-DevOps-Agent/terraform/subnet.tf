######### Subnets (Dynamic) #########
#trivy:ignore:AWS-0164
resource "aws_subnet" "subnets" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.egp_vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.public

  tags = merge(local.common_tags, {
    Name = "${var.project_name}_${var.environment}_${each.key}_subnet"
  })
}
