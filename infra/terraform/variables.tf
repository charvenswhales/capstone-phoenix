variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  default     = "capstone-phoenix"
}

variable "key_name" {
  description = "AWS key pair name"
  default     = "bincom-key"
}

variable "my_ip" {
  description = "Your IP address for SSH access"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Ubuntu 22.04 AMI ID for us-east-1"
  default     = "ami-0d16758616f047bbf"
}
