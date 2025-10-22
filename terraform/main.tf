provider "aws" {
  region = var.aws_region
}

# Generate a new SSH key pair dynamically
resource "tls_private_key" "dynamic_key" {
  algorithm = "ED25519"
}

resource "random_string" "key_suffix" {
  length  = 6
  upper   = false
  lower   = true
  number  = true
  special = false
}

resource "aws_key_pair" "deployment_key" {
  key_name   = "${var.app_name}-${random_string.key_suffix.result}"
  public_key = tls_private_key.dynamic_key.public_key_openssh
  tags = {
    Name = "${var.app_name}-${random_string.key_suffix.result}"
  }
}

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

resource "aws_instance" "product_service_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployment_key.key_name
  vpc_security_group_ids      = [aws_security_group.product_service_sg.id]
  associate_public_ip_address = true

  tags = {
    Name        = "${var.app_name}-instance"
    Environment = var.environment
  }

  depends_on = [aws_key_pair.deployment_key]
}

# Output the private key so GitHub Actions can use it
output "private_key_pem" {
  value     = tls_private_key.dynamic_key.private_key_pem
  sensitive = true
}
