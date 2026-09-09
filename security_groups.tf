resource "aws_security_group" "sandbox_sg" {
  name        = "sandbox_sg"
  description = "Security group for sandbox EC2 instance"
  vpc_id      = module.vpc.vpc_id


  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
