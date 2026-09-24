######### NAT EC2 Instance #########
resource "aws_instance" "nat_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.instance_key

  #NAT instance should be launched in public subnet so that Private instances can access internet as per requirements
  subnet_id = local.subnet_ids["public_a"]

  # Attach NAT security group
  vpc_security_group_ids = [aws_security_group.nat_sg.id]

  # Disable source/dest check so it can forward traffic 
  source_dest_check = false

  # Give it a public IP (Elastic IP will override this)
  associate_public_ip_address = true

  # Require IMDSv2
  metadata_options {
    http_tokens = "required"
  }

  # Root Block Device Variables
  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    encrypted   = true
  }

  # Reference external NAT script
  user_data = file("${path.module}/userdata/nat.sh")

  tags = merge(local.common_tags, {
    Name = "${var.project_name}_${var.environment}_nat_instance"
  })

}