######### Locals #########
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "Amit"
  }

  # Subnet IDs map
  subnet_ids = {
    public_a   = aws_subnet.subnets["public_a"].id
    public_b   = aws_subnet.subnets["public_b"].id
    private_a  = aws_subnet.subnets["private_a"].id
    private_b  = aws_subnet.subnets["private_b"].id
    management = aws_subnet.subnets["management"].id
  }

  # Subnet CIDRs map
  subnet_cidrs = {
    public_a   = var.subnets["public_a"].cidr_block
    public_b   = var.subnets["public_b"].cidr_block
    private_a  = var.subnets["private_a"].cidr_block
    private_b  = var.subnets["private_b"].cidr_block
    management = var.subnets["management"].cidr_block
  }

  # Security Group IDs map
  sg_ids = {
    bastion_sg   = aws_security_group.bastion_sg.id
    nat_sg       = aws_security_group.nat_sg.id
    k3_master_sg = aws_security_group.k3_master_sg.id
    k3_worker_sg = aws_security_group.k3_worker_sg.id
    egp_db_sg    = aws_security_group.egp_db_sg.id
    monitor_sg   = aws_security_group.monitor_sg.id
    egp_alb      = aws_security_group.egp_alb.id
  }
}
