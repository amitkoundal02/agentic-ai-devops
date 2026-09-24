######### Bastion Security Group #########
# Intentional: Bastion requires outbound internet access for administration and updates.
#trivy:ignore:AWS-0104
resource "aws_security_group" "bastion_sg" {
  name        = "${var.project_name}_${var.environment}_bastion_sg"
  description = "Security group for Bastion host"
  vpc_id      = aws_vpc.egp_vpc.id

  ingress {
    description = "SSH from admin IPs only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.admin_ips # ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, {
    Name = "${var.project_name}_${var.environment}_bastion_sg"
  })
}

######### NAT_SG  #########
#trivy:ignore:AWS-0104
resource "aws_security_group" "nat_sg" {
  description = "Security group for NAT Instance"
  name        = "${var.project_name}_${var.environment}_nat_sg"
  vpc_id      = aws_vpc.egp_vpc.id


  ingress {
    description = "SSH from admin IPs only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.admin_ips # ["0.0.0.0/0"]

  }

  ingress {
    description = "Allow traffic from private subnets"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      local.subnet_cidrs["private_a"],
      local.subnet_cidrs["private_b"],
      local.subnet_cidrs["management"]
    ]
  }
  egress {
    description = "NAT Instance can access the internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = merge(local.common_tags, {
    Name = "${var.project_name}_${var.environment}_nat_sg"
  })
}

######### Load Balancer Security Group #########
# Intentional: ALB outbound access will be refined when target groups are implemented.
#trivy:ignore:AWS-0104
resource "aws_security_group" "egp_alb" {
  name        = "${var.project_name}_${var.environment}_alb_sg"
  description = "ALB Security Group"
  vpc_id      = aws_vpc.egp_vpc.id


  ingress {
    description = "SSH from admin IPs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.admin_ips # ["0.0.0.0/0"] 
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HAProxy stats from laptop only"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.admin_ips # ["0.0.0.0/0"] 
  }

  ingress {
    description = "Node exporter metrics from monitor"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    security_groups = [
      aws_security_group.monitor_sg.id
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}_${var.environment}_egp_alb"
  })
}

######### K3_Master  ######### 
# Intentional: K3s requires outbound internet access through the NAT instance.
#trivy:ignore:AWS-0104
resource "aws_security_group" "k3_master_sg" {
  description = "Security group for K3s Master"
  name        = "${var.project_name}_${var.environment}_k3_master_sg"
  vpc_id      = aws_vpc.egp_vpc.id

  ingress {
    description = "k3s API server from worker + management subnets"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [
      local.subnet_cidrs["private_a"],
      local.subnet_cidrs["private_b"],
      local.subnet_cidrs["management"]
    ]
  }

  ingress {
    description     = "SSH from bastion only"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description     = "Node exporter metrics from monitor"
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    security_groups = [aws_security_group.monitor_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}_${var.environment}_k3_master_sg"
  })
}


######### Worker_SG  ######### 
# Intentional: K3s requires outbound internet access through the NAT instance.
#trivy:ignore:AWS-0104
resource "aws_security_group" "k3_worker_sg" {
  description = "Security group for K3s Worker"
  name        = "${var.project_name}_${var.environment}_k3_worker_sg"
  vpc_id      = aws_vpc.egp_vpc.id

  ingress {
    description = "Allow traffic from private subnets"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      local.subnet_cidrs["private_a"],
      local.subnet_cidrs["private_b"]
    ]
  }
  ingress {
    description = "Allow traffic from private subnets"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [
      aws_security_group.bastion_sg.id,
      aws_security_group.k3_master_sg.id
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}_${var.environment}_k3_worker_sg"
  })
}

######### Database Security Group #########
resource "aws_security_group" "egp_db_sg" {
  description = "Database Security Group"
  name        = "${var.project_name}_${var.environment}_db_sg"
  vpc_id      = aws_vpc.egp_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }


  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    security_groups = [
      aws_security_group.k3_master_sg.id,
      aws_security_group.k3_worker_sg.id
    ]

  }

  ingress {
    description     = "Node exporter metrics from monitor"
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    security_groups = [aws_security_group.monitor_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}_${var.environment}_db_sg"
  })
}



######### Monitor_SG ######### 

# Intentional: Monitoring requires outbound internet access for updates and monitoring components.
#trivy:ignore:AWS-0104
resource "aws_security_group" "monitor_sg" {
  description = "Security group for Monitoring"
  name        = "${var.project_name}_${var.environment}_monitor_sg"
  vpc_id      = aws_vpc.egp_vpc.id

  ingress {
    description     = "ssh use"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description = "grafana use"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = var.admin_ips # ["0.0.0.0/0"] 
  }

  ingress {
    description = "promethus use"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = var.admin_ips # ["0.0.0.0/0"] 
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}_${var.environment}_monitor_sg"
  })
}



