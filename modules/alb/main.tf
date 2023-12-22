# Crear un Application Load Balancer (ALB)
resource "aws_lb" "my_lb" {
    name               = "my-lb"
    internal           = false
    load_balancer_type = "application"
    subnets            = [var.subnet_public_1_id_from_networking_module,var.subnet_public_2_id_from_networking_module]
}

# Crear un grupo objetivo para el ALB
resource "aws_lb_target_group" "my_target_group" {
    name       = "my-target-group"
    port       = 80
    protocol   = "HTTP"
    vpc_id     = var.vpc_id_from_networking_module
}

# Listener ALB
resource "aws_lb_listener" "example_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

