
# terraform import aws_s3_bucket.example-infra23 example-infra23

# Configuramos el proveedor de AWS-git 
provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "MainVpc"
    }
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    count = length(var.public_subnet_cidr)
    cidr_block = var.public_subnet_cidr[count.index]
    availability_zone = var.availability_zone
    map_public_ip_on_launch = true
    tags = {
        Name = "PublicSubnet"
    }
}

resource "aws_subnet" "public_2" {
    vpc_id = aws_vpc.main.id
    count = length(var.public_subnet_cidr)
    cidr_block = var.public_subnet_cidr[count.index]
    availability_zone = var.availability_zone_2
    map_public_ip_on_launch = true
    tags = {
        Name = "PublicSubnet"
    }
}

# Crear un gateway de internet
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "InternetGateway"
    }
}


# Crear tabla de rutas 
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
    tags = {
        Name = "PublicRouteTable"
    }
}

# Asociar la subred publica a la tabla de rutas y agregar una ruta al gateway de internet
resource "aws_route_table_association" "public_route_association" {
    subnet_id = aws_subnet.public[0].id
    route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "example" {
    name = "example_security_group"
    description = "Allow inbound traffic"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port    = 80
        to_port      = 80
        protocol     = "tcp"
        cidr_blocks  =["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks =["0.0.0.0/0"]
    }
}

#crear un ECS Cluster
resource "aws_ecs_cluster" "my_cluster" {
    name = "my_cluster"
}

# Definicion de tareas
resource "aws_ecs_task_definition" "example_task" {
    family                   = "example_task"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 256
    memory                   = 512

    container_definitions = jsonencode([{
      name  = "example-container"
      image = "nginx:latest"
      portMappings = [{
        containerPort = 80
        hostPort      = 80
      }]
    }])
}

# Servicio ECS
resource "aws_ecs_service" "example_service" {
  name            = "example-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.example_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.example.id]
  }

}


# Crear un Application Load Balancer (ALB)
resource "aws_lb" "my_lb" {
    name               = "my-lb"
    internal           = false
    load_balancer_type = "application"
    subnets            = [aws_subnet.public[*].id,aws_subnet.public_2[*].id]
}

# Crear un grupo objetivo para el ALB
resource "aws_lb_target_group" "my_target_group" {
    name       = "my-target-group"
    port       = 80
    protocol   = "HTTP"
    vpc_id     = aws_vpc.main.id
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

# Depósito S3
resource "aws_s3_bucket" "example_infra23" {
  bucket = "example-infra23"  
}

# configurar el backend de Terraform para almacenar el tfstate en s3. 
terraform {
    backend "s3" {
        bucket = "example-infra23"
        key    = "terraform.tfstate"
        region = "us-east-1"
        access_key = "AKIAVXLCKSOAGNQYMXZN"
        secret_key = "wZ3Qn8nq6JRYo69X9MLPr98L+jqc38iegbpUzpqH"
    }
}











