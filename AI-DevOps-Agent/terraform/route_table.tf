######### Public Route Table #########
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.egp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.egp_igw.id
  }
  tags = merge(local.common_tags, {
    Name = "${var.project_name}_${var.environment}_public_route"
  })
}

######### Private Route Table #########
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.egp_vpc.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}_${var.environment}_private_route"
  })
}

######### Route Table Associations #########
resource "aws_route_table_association" "public_route_a" {
  subnet_id      = local.subnet_ids["public_a"]
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public_route_b" {
  subnet_id      = local.subnet_ids["public_b"]
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "private_route_a" {
  subnet_id      = local.subnet_ids["private_a"]
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private_route_b" {
  subnet_id      = local.subnet_ids["private_b"]
  route_table_id = aws_route_table.private_route.id
}
resource "aws_route_table_association" "management_route" {
  subnet_id      = local.subnet_ids["management"]
  route_table_id = aws_route_table.private_route.id
}

## Fetch the ENI attached to NAT instance
data "aws_network_interface" "nat_eni" {
  filter {
    name   = "attachment.instance-id"
    values = [aws_instance.nat_instance.id]
  }
}

# NAT Route for Private Subnets
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_route.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = data.aws_network_interface.nat_eni.id
}
