######### variables #########
variable "aws_region" {
  type        = string
  description = "AWS Region where resource will be created"
  default     = "ap-south-1"

}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "egp"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "lab"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    public            = bool
  }))

  default = {
    public_a = {
      cidr_block        = "10.1.1.0/24"
      availability_zone = "ap-south-1a"
      public            = true
    }
    public_b = {
      cidr_block        = "10.1.2.0/24"
      availability_zone = "ap-south-1b"
      public            = true
    }
    private_a = {
      cidr_block        = "10.1.11.0/24"
      availability_zone = "ap-south-1a"
      public            = false
    }
    private_b = {
      cidr_block        = "10.1.12.0/24"
      availability_zone = "ap-south-1b"
      public            = false
    }
    management = {
      cidr_block        = "10.1.21.0/24"
      availability_zone = "ap-south-1a"
      public            = false
    }
  }
}

variable "instance_type" {
  type        = string
  description = "EC2 Instance Type"
  default     = "t3.micro"

}

variable "instance_key" {
  type    = string
  default = "instance_key"

}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 10
}

variable "root_volume_type" {
  description = "Root EBS volume type"
  type        = string
  default     = "gp3"
}

variable "admin_ips" {
  description = "IPS allowed for SSH"
  type        = list(string)
}




variable "instances" {
  type = map(object({
    subnet_key = string
    sg_key     = string
    name       = string
    public     = bool
    ecr_access = bool
  }))
  default = {
    bastion = {
      subnet_key = "public_a"
      sg_key     = "bastion_sg"
      name       = "bastion"
      public     = true
      ecr_access = false
    }

    k3_master = {
      subnet_key = "private_a"
      sg_key     = "k3_master_sg"
      name       = "k3_master"
      public     = false
      ecr_access = true
    }
    k3_worker = {
      subnet_key = "private_b"
      sg_key     = "k3_worker_sg"
      name       = "k3_worker"
      public     = false
      ecr_access = true
    }
    db = {
      subnet_key = "private_a"
      sg_key     = "egp_db_sg"
      name       = "db"
      public     = false
      ecr_access = false
    }
    monitoring = {
      subnet_key = "private_b"
      sg_key     = "monitor_sg"
      name       = "monitoring"
      public     = false
      ecr_access = false
    }
    alb = {
      subnet_key = "public_b"
      sg_key     = "egp_alb"
      name       = "alb"
      public     = true
      ecr_access = false
    }
  }

}

