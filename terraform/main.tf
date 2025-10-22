provider "aws" {
  region = var.aws_region
}

# Set up an AWS keypair starting from an existing public key

resource "aws_key_pair" "deployment_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
  tags = {
    Name = "${var.key_name}"
  }
}

# Security Group

resource "aws_security_group" "product_service_sg" {
  name_prefix = "${var.app_name}-sg"
  description = "Allow SSH and application traffic"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Webapp port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-security-group"
  }
}

# EC2 instance

resource "aws_instance" "product_service_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployment_key.key_name
  security_groups = [aws_security_group.product_service_sg.name]
  associate_public_ip_address = false

  tags = {
    Name = "${var.app_name}-instance"
    Environment = var.environment
  }

  depends_on = [aws_eip.instance_eip] 
}
