######### Network Information #########
output "network_info" {
  description = "VPC Networking Details"

  value = {
    vpc_id = aws_vpc.egp_vpc.id

    internet_gateway = aws_internet_gateway.egp_igw.id

    public_subnet_a = aws_subnet.subnets["public_a"].id
    public_subnet_b = aws_subnet.subnets["public_b"].id

    private_subnet_a  = aws_subnet.subnets["private_a"].id
    private_subnet_b  = aws_subnet.subnets["private_b"].id
    management_subnet = aws_subnet.subnets["management"].id
  }
}

output "instance_ips" {
  description = "EC2 Instances IPs"

  value = {
    bastion    = aws_instance.servers["bastion"].public_ip
    nat        = aws_instance.nat_instance.public_ip
    k3_master  = aws_instance.servers["k3_master"].private_ip
    k3_worker  = aws_instance.servers["k3_worker"].private_ip
    db         = aws_instance.servers["db"].private_ip
    monitoring = aws_instance.servers["monitoring"].private_ip
    alb        = aws_instance.servers["alb"].public_ip
  }
}

######### Instance Information #########
output "instance_info" {
  description = "EC2 Instances Details"

  value = {
    bastion    = aws_instance.servers["bastion"].id
    nat        = aws_instance.nat_instance.id
    k3_master  = aws_instance.servers["k3_master"].id
    k3_worker  = aws_instance.servers["k3_worker"].id
    db         = aws_instance.servers["db"].id
    monitoring = aws_instance.servers["monitoring"].id
    alb        = aws_instance.servers["alb"].id
  }
}
######### CIDR Information #########
output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.egp_vpc.cidr_block
}

output "subnet_cidrs" {
  description = "CIDR blocks of all subnets"
  value       = local.subnet_cidrs
}
