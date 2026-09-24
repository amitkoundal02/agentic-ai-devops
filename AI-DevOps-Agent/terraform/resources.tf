######### EC2 Servers #########
resource "aws_instance" "servers" {
  for_each = var.instances

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.instance_key
  metadata_options {
    http_tokens = "required"
  }

  # Resolve subnet from locals map
  subnet_id = local.subnet_ids[each.value.subnet_key]


  # Resolve SG from locals map
  vpc_security_group_ids = [local.sg_ids[each.value.sg_key]]

  associate_public_ip_address = each.value.public
  iam_instance_profile        = each.value.ecr_access ? aws_iam_instance_profile.ecr_read_profile.name : null

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    encrypted   = true
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}_${var.environment}_${each.value.name}"
  })
}
