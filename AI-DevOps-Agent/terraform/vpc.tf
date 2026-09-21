######### VPC #########
resource "aws_vpc" "egp_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}_${var.environment}_vpc"
  })
}

