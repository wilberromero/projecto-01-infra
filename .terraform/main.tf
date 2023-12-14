 Configuramos el proveedor de AWS
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
    vpc_id = aws_vpc.main.vpc_id
    cidr_block = var.public_subnet_cidr
    availability_zone = var.availability_zone
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

    route = {
        cidr_block = "0.0.0.0/0
        gateway_id = aws_internet_gateway.gw.id
    }
    tags = {
        Name = "PublicRouteTable"
    }
}

# Asociar la subred publica a la tabla de rutas y agregar una ruta al gateway de internet
resource "aws_route_table_association" "public_route_association" {
    subnet_id = aws_subnet.public.id
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

resource "aws_ecs_task_definition" "example_tast"{
    family                   = "example_tast"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = "256"
    memory                   = "512"

    container_definitions = jsonencode([
        {
            name  = "example-container"
            image = "nginx:latest"
            portMappings = [
                containerPort = 80
                hostPort      = 80
            ]
        }
    ])
}

# Servicio ECS
resource "aws_ecs_service" "example_service" {
  name            = "example-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.example_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = [aws_subnet.public.id]
    security_groups = [aws_security_group.example.id]
  }

}


# Crear un Application Load Balancer (ALB)
resource "aws_lb" "my_lb" {
    name               = "my_lb"
    internal           = false
    load_balancer_type = "application"
    subnets            = [aws_subnet.public.id]
}

# Crear un grupo objetivo para el ALB
resource "aws_lb_target_group" "my_target_group" {
    name       = "my_target_group"
    port       = 80
    protocol   = "HTTP"
    vpc_id     = aws_vpc.main.id
}

# Listener ALB
resource "aws_lb_listener" "example_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

# Depósito S3
resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"
  acl    = "private"
  // Otras configuraciones del depósito S3
}

# Distribución de CloudFront
resource "aws_cloudfront_distribution" "example_distribution" {
  origin {
    domain_name = aws_s3_bucket.example_bucket.bucket_regional_domain_name
    origin_id   = "S3-example-bucket"
  }
  // Otras configuraciones de la distribución de CloudFront
}

# Identidad de Acceso de Origen (OAI)
resource "aws_cloudfront_origin_access_identity" "example_oai" {
  comment = "example-origin-access-identity"
}

# Política de Depósito OAI
resource "aws_s3_bucket_policy" "example_bucket_policy" {
  bucket = aws_s3_bucket.example_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "GrantCloudFrontAccess",
        Effect    = "Allow",
        Principal = {
          CanonicalUser = aws_cloudfront_origin_access_identity.example_oai.cloudfront_access_identity_path
        },
        Action    = ["s3:GetObject"],
        Resource  = "${aws_s3_bucket.example_bucket.arn}/*"
      }
    ]
  })
}

# configurar el backend de Terraform para almacenar el tfstate en s3. 
terraform = {
    backend "s3" {
        bucket = "aws_s3_bucket.example_bucket.bucket"
        key = "terraform.tfstate"
        region = var.region
    }
}









