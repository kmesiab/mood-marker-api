resource "aws_vpc" "mood_marker_api_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "mood-marker-api-vpc"
  }
}

resource "aws_subnet" "mood_marker_api_subnet_1" {
  vpc_id            = aws_vpc.mood_marker_api_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "mood-marker-api-subnet-1"
  }
}

resource "aws_subnet" "mood_marker_api_subnet_2" {
  vpc_id            = aws_vpc.mood_marker_api_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "mood-marker-api-subnet-2"
  }
}

resource "aws_security_group" "mood_marker_api_sg" {
  name        = "mood-marker-api-security-group"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.mood_marker_api_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "my-security-group"
  }
}
