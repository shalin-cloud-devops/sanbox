resource "aws_iam_role" "sandbox_ssm" {
  name = "sandbox_ssm"
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
}

resource "aws_iam_role_policy_attachment" "attach_ssm_policy_role" {
  role       = aws_iam_role.sandbox_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

}

resource "aws_iam_instance_profile" "sandbox_profile" {
  name = "sandbox-ssm-profile"
  role = aws_iam_role.sandbox_ssm.name
}

module "sandbox_host" {
  source        = "terraform-aws-modules/ec2-instance/aws"
  name          = "sandbox_Host"
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  monitoring    = true

  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [aws_security_group.sandbox_sg.id]
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.sandbox_profile.name
  user_data            = file("${path.module}/bootstrap_sandbox.sh")

}

