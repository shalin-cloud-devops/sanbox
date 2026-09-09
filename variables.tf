
variable "aws_region" {
  description = "Default AWS region"
  type        = string
  default     = "us-east-1"

}

variable "ec2_instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t3.large"
}
