######### IAM Role for ECR Read Access #########
resource "aws_iam_role" "ecr_read_role" {
  name = "${var.project_name}_${var.environment}_ecr_read_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${var.project_name}_${var.environment}_ecr_read_role"
  })
}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  role       = aws_iam_role.ecr_read_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ecr_read_profile" {
  name = "${var.project_name}_${var.environment}_ecr_read_profile"
  role = aws_iam_role.ecr_read_role.name

  tags = merge(local.common_tags, {
    Name = "${var.project_name}_${var.environment}_ecr_read_profile"
  })
}
