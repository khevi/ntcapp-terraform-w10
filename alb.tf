############################################
# Target Groups
############################################
resource "aws_lb_target_group" "tg1" {
  name        = "ntc-tg1"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.my-vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 6
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "tg2" {
  name        = "ntc-tg2"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.my-vpc.id
}

############################################
# Attach EC2 to Target Groups
############################################
resource "aws_lb_target_group_attachment" "server1_tg1" {
  target_group_arn = aws_lb_target_group.tg1.arn
  target_id        = aws_instance.server1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "server2_tg2" {
  target_group_arn = aws_lb_target_group.tg2.arn
  target_id        = aws_instance.server1.id
  port             = 80
}

############################################
# Application Load Balancer
############################################
resource "aws_lb" "name" {
  name               = "ntc-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]
  enable_deletion_protection = false
}

############################################
# Listener
############################################
resource "aws_lb_listener" "name" {
  load_balancer_arn = aws_lb.name.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg1.arn
  }
}
