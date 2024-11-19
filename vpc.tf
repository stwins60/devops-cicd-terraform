resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a" # Choose an AZ in your region
  map_public_ip_on_launch = true

  tags = {
    Name = "my-subnet"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all_sg"
  description = "Security group that allows all inbound and outbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  # Ingress (Inbound) rule: allows all traffic
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow all IPs
  }

  # Egress (Outbound) rule: allows all traffic
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow all IPs
  }

  tags = {
    Name = "allow-all-sg"
  }
}
