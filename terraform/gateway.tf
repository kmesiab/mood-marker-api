resource "aws_internet_gateway" "mood_marker_api_igw" {
  vpc_id = aws_vpc.mood_marker_api_vpc.id

  tags = {
    Name = "mood-marker-api-igw"
  }
}

resource "aws_lb_target_group" "mood_maker_api_target_group" {
  name     = "mood-maker-api-tg"
  port     = 443
  protocol = "HTTP"
  vpc_id   = aws_vpc.mood_marker_api_vpc.id
  target_type = "ip"
}

resource "aws_lb" "mood_maker_api_lb" {
  name               = "mood-maker-api-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mood_marker_api_sg.id]
  subnets            = [aws_subnet.mood_marker_api_subnet_1.id, aws_subnet.mood_marker_api_subnet_2.id]
}
